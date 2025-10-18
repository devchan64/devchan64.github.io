#!/usr/bin/env bash
set -Eeuo pipefail

# === Config ===
BACKEND="${1:-onnx}"            # choices: onnx | --backend tensorrt
if [[ "${BACKEND}" == "--backend" ]]; then
  BACKEND="${2:-onnx}"
fi

# onnxruntime GPU bundle version (Linux x64)
# 참고: Arch AUR가 1.17.1 GPU 번들을 사용한 전례가 있음. 필요 시 최신으로 바꿔도 됨. :contentReference[oaicite:4]{index=4}
ORT_VER="${ORT_VER:-1.17.1}"
ORT_TGZ="onnxruntime-linux-x64-gpu-${ORT_VER}.tgz"
ORT_URL="https://github.com/microsoft/onnxruntime/releases/download/v${ORT_VER}/${ORT_TGZ}"

# obs-backgroundremoval 최신 .deb 자동 탐색(리눅스/우분투용)
# 플러그인 README: 우분투 PPA 설치 시 releases의 .deb 사용 권장. :contentReference[oaicite:5]{index=5}
PLUGIN_OWNER="royshil"
PLUGIN_REPO="obs-backgroundremoval"

# === Helpers ===
msg() { echo -e "\033[1;32m[+] $*\033[0m"; }
warn() { echo -e "\033[1;33m[!] $*\033[0m"; }
err() { echo -e "\033[1;31m[✗] $*\033[0m" >&2; exit 1; }

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    err "root 권한이 필요합니다. sudo로 실행하세요."
  fi
}

has_cmd() { command -v "$1" >/dev/null 2>&1; }

apt_install() {
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$@"
}

# === Start ===
require_root

msg "시스템 업데이트"
apt-get update -y
apt-get install -y curl ca-certificates jq lsb-release software-properties-common

# 0) Flatpak OBS/플러그인 제거(있다면 충돌 방지)
if has_cmd flatpak; then
  if flatpak list | grep -q com.obsproject.Studio; then
    warn "Flatpak OBS 감지됨 → 제거하여 네이티브와 충돌 방지"
    flatpak uninstall -y com.obsproject.Studio || true
  fi
  if flatpak list | grep -q com.obsproject.Studio.Plugin.BackgroundRemoval; then
    warn "Flatpak BackgroundRemoval 플러그인 감지됨 → 제거"
    flatpak uninstall -y com.obsproject.Studio.Plugin.BackgroundRemoval || true
  fi
fi

# 1) 네이티브 OBS 설치(PPA)
if ! has_cmd obs; then
  msg "OBS PPA 추가 및 설치 (네이티브)"
  add-apt-repository -y ppa:obsproject/obs-studio
  apt-get update -y
  apt_install obs-studio
else
  msg "OBS 이미 설치됨: $(obs --version | head -n1)"
fi

# 2) GPU 런타임 준비
if [[ "${BACKEND}" == "onnx" ]]; then
  msg "백엔드: ONNX Runtime (CUDA) 준비"
  # CUDA/cuDNN은 드라이버/툴킷이 이미 설치되어 있다는 전제. ONNX 문서 참고. :contentReference[oaicite:6]{index=6}
  TMPD="$(mktemp -d)"
  pushd "${TMPD}" >/dev/null

  msg "onnxruntime GPU 번들 다운로드: ${ORT_URL}"
  curl -fL -o "${ORT_TGZ}" "${ORT_URL}" || err "ONNX Runtime GPU ${ORT_VER} 다운로드 실패"
  tar xf "${ORT_TGZ}"

  # 표준 위치 배치
  ORT_DIR="/usr/local/onnxruntime-gpu-${ORT_VER}"
  install -d "${ORT_DIR}"
  cp -a "onnxruntime-linux-x64-gpu-${ORT_VER}/." "${ORT_DIR}/"

  # 공유 라이브러리 링크 등록
  # 주요 so: libonnxruntime.so, libonnxruntime_providers_cuda.so 등
  find "${ORT_DIR}" -maxdepth 1 -type f -name "lib*.so*" -exec ln -sf {} /usr/local/lib/ \;

  ldconfig

  popd >/dev/null
  rm -rf "${TMPD}"
  msg "ONNX Runtime GPU 배치 완료 (/usr/local/onnxruntime-gpu-${ORT_VER})"

elif [[ "${BACKEND}" == "tensorrt" ]]; then
  msg "백엔드: TensorRT 경로 점검"
  # NVIDIA 공식 가이드에 따라 CUDA → TensorRT 로컬 리포 설치가 필요. (자동 설치는 배포/버전 상이로 불안정)
  # 안내: https://docs.nvidia.com/deeplearning/tensorrt/latest/installing-tensorrt/installing.html :contentReference[oaicite:7]{index=7}

  if ! has_cmd nvidia-smi; then
    err "nvidia-smi 없음 → NVIDIA 드라이버가 설치되지 않은 듯 합니다."
  fi

  if ! has_cmd trtexec; then
    warn "TensorRT(trtexec) 미설치 상태입니다."
    echo "다음 문서를 따라 Ubuntu 24.04 + CUDA 버전에 맞는 TensorRT 로컬 리포를 설치하세요:"
    echo "  - NVIDIA TensorRT 설치 가이드(로컬 리포): docs.nvidia.com/deeplearning/tensorrt/latest/installing-tensorrt/installing.html"
    echo "설치 후 재실행하면 라이브러리 검증을 수행합니다."
  else
    msg "trtexec 감지됨: $(trtexec --version 2>/dev/null || true)"
  fi

  # 공용 라이브러리 존재 점검
  if ldconfig -p | grep -q libnvinfer.so; then
    msg "libnvinfer.so 탐지됨 → TensorRT 런타임 존재"
  else
    warn "libnvinfer.so 미탐지 → TensorRT 런타임 설치가 필요합니다."
  fi
else
  err "알 수 없는 백엔드: ${BACKEND} (onnx | tensorrt)"
fi

# 3) obs-backgroundremoval 플러그인(.deb) 설치
# GitHub API로 최신 릴리스 .deb 자산 자동 탐색
msg "obs-backgroundremoval 최신 .deb 검색 및 설치"
REL_API="https://api.github.com/repos/${PLUGIN_OWNER}/${PLUGIN_REPO}/releases/latest"
JSON="$(curl -fsSL "${REL_API}")" || err "GitHub API 호출 실패"
DEB_URL="$(echo "${JSON}" | jq -r '.assets[] | select(.name|endswith(".deb")) | .browser_download_url' | head -n1)"
[[ -n "${DEB_URL}" && "${DEB_URL}" != "null" ]] || err "릴리스 .deb 자산을 찾지 못했습니다. 수동 확인 필요"

TMPD="$(mktemp -d)"
pushd "${TMPD}" >/dev/null
msg "다운로드: ${DEB_URL}"
curl -fL -O "${DEB_URL}"
DEB_FILE="$(ls *.deb | head -n1)"
dpkg -i "${DEB_FILE}" || apt-get -f install -y
popd >/dev/null
rm -rf "${TMPD}"
msg "플러그인 설치 완료"

# 4) 최종 안내
echo
msg "설치/구성 완료 🎉"
echo "다음 순서로 확인하세요:"
echo "  1) OBS 실행 → 비디오 소스 선택 → '배경 제거' 필터 추가"
if [[ "${BACKEND}" == "onnx" ]]; then
  echo "  2) Inference Device(추론 장치)에서 GPU(ONNX/CUDA 계열)가 활성화되었는지 로그에서 확인"
  echo "     (도움말 → 로그 파일 → 현재 로그 보기) onnxruntime CUDA 프로바이더 로드 메시지 확인"
elif [[ "${BACKEND}" == "tensorrt" ]]; then
  echo "  2) Inference Device에서 'GPU - TensorRT' 선택 후, 로그에 엔진 빌드/로드 성공 여부 확인"
  echo "     실패 시 TensorRT/쿠다 버전 불일치 가능성이 큼 → NVIDIA 설치 가이드 참조"
fi
echo
