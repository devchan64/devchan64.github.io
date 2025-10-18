#!/usr/bin/env bash
# Ubuntu 24.04 (Noble)
# CUDA 13.0.2 (local repo .deb) + TensorRT (pip --user only) + optional drivers
# - Strict errors (no fallbacks): set -Eeuo pipefail
# - CUDA: local repo .deb flow (resume downloads)
# - TensorRT: ALWAYS install via pip --user (no venv)
# - Optional drivers: nvidia-open / cuda-drivers (enabled only by flags)
# - On error: purge conflicting CUDA APT sources/keyring/pin & clean APT cache, then exit

set -Eeuo pipefail

############################################
# ============ DEFAULT SETTINGS ============
############################################
# CUDA 13.0.2 local repo defaults (Ubuntu 24.04, driver 580.95.05)
CUDA_PIN_URL="${CUDA_PIN_URL:-https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin}"
CUDA_LOCAL_DEB_URL="${CUDA_LOCAL_DEB_URL:-https://developer.download.nvidia.com/compute/cuda/13.0.2/local_installers/cuda-repo-ubuntu2404-13-0-local_13.0.2-580.95.05-1_amd64.deb}"
CUDA_LOCAL_REPO_DIR_DEFAULT="/var/cuda-repo-ubuntu2404-13-0-local"
CUDA_TOOLKIT_PKG="${CUDA_TOOLKIT_PKG:-cuda-toolkit-13-0}"

# Optional drivers (OFF by default; set to 1 to install)
INSTALL_NVIDIA_OPEN="${INSTALL_NVIDIA_OPEN:-0}"   # 1: apt-get install -y nvidia-open
INSTALL_CUDA_DRIVERS="${INSTALL_CUDA_DRIVERS:-0}" # 1: apt-get install -y cuda-drivers

# TensorRT (pip --user only)
TENSORRT_PIP_VERSION="${TENSORRT_PIP_VERSION:-}"  # e.g., 10.2.0 (empty = latest)
PYTHON_BIN="${PYTHON_BIN:-python3}"               # python executable

# Non-interactive mode (no prompts)
NON_INTERACTIVE="${NON_INTERACTIVE:-1}"

# Download directory (for resume downloads)
DOWNLOAD_DIR="${DOWNLOAD_DIR:-$HOME/Downloads}"
mkdir -p "$DOWNLOAD_DIR"

############################################
# ================== UTILS =================
############################################
err()  { echo "[ERROR] $*" >&2; exit 1; }
info() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*"; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || err "'$1' 명령을 찾을 수 없습니다. 설치 후 다시 실행하세요."; }

download_resume() { # $1=url  $2=dest
  local url="$1" dest="$2"
  info "다운로드 (resume 지원): $url"
  curl -fL --retry 3 --retry-all-errors -C - -o "$dest" "$url"
  info "완료: $dest"
}

detect_ubuntu_2404() {
  local id ver
  id="$(. /etc/os-release; echo "$ID")"
  ver="$(. /etc/os-release; echo "$VERSION_ID")"
  [[ "$id" == "ubuntu" && "$ver" == "24.04" ]] || err "이 스크립트는 Ubuntu 24.04 전용입니다. (감지됨: $id $ver)"
}

sudo_apt_install() { sudo apt-get update -y; sudo apt-get install -y "$@"; }

############################################
# ============== ERROR CLEANUP =============
############################################
cleanup_cuda_apt_on_error() {
  local ec="$1" cmd="$2"
  echo
  echo "------------------------------------"
  echo "[CLEANUP] CUDA APT/Keyring 정리 시작 (exit=$ec)"
  echo "[CLEANUP] 실패 명령: $cmd"
  sudo rm -f \
    /etc/apt/sources.list.d/cuda-*.list \
    /etc/apt/sources.list.d/nvidia*cuda*.list \
    /etc/apt/sources.list.d/*cuda*.list \
    /usr/share/keyrings/cuda-archive-keyring.gpg \
    /etc/apt/preferences.d/cuda-repository-pin-600 || true
  sudo apt-get clean || true
  sudo rm -rf /var/lib/apt/lists/* || true
  echo "[CLEANUP] 정리 완료. 네트워크/프록시 환경 확인 후 재실행하세요."
  echo "------------------------------------"
  exit "$ec"
}
trap 'cleanup_cuda_apt_on_error $? "$BASH_COMMAND"' ERR

############################################
# ============== PREFLIGHT =================
############################################
detect_ubuntu_2404
need_cmd sudo; need_cmd curl; need_cmd dpkg; need_cmd apt-get; need_cmd uname

info "기본 도구 설치 확인 및 설치"
sudo_apt_install ca-certificates gnupg lsb-release

info "NVIDIA 드라이버 상태 확인"
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi || err "nvidia-smi 실행 실패: 드라이버 상태를 확인하세요."
  DRV_VER="$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -n1 || true)"
  info "감지된 드라이버 버전: ${DRV_VER:-unknown}"
else
  warn "nvidia-smi 없음 — 드라이버가 설치되지 않았거나 로드되지 않았습니다."
fi

# Optional driver installs (explicit only)
if [[ "$INSTALL_NVIDIA_OPEN" == "1" || "$INSTALL_CUDA_DRIVERS" == "1" ]]; then
  info "드라이버 패키지 설치 요청 감지"
  sudo apt-get update -y
  if [[ "$INSTALL_NVIDIA_OPEN" == "1" ]]; then
    info "설치: nvidia-open"
    sudo apt-get install -y nvidia-open
  fi
  if [[ "$INSTALL_CUDA_DRIVERS" == "1" ]]; then
    info "설치: cuda-drivers (메타패키지)"
    sudo apt-get install -y cuda-drivers
  fi
  echo
  info "드라이버 설치가 완료되었습니다. 재부팅 후 nvidia-smi 확인을 권장합니다."
fi

############################################
# ========== CUDA (LOCAL REPO .DEB) ========
############################################
info "CUDA 13.0.2 로컬 리포 .deb 설치"

# 0) 이전 구성 정리
sudo rm -f \
  /etc/apt/sources.list.d/cuda-*.list \
  /etc/apt/sources.list.d/nvidia*cuda*.list \
  /usr/share/keyrings/cuda-archive-keyring.gpg \
  /etc/apt/preferences.d/cuda-repository-pin-600

# 1) pin 파일 다운로드 및 배치
TMP_PIN="$DOWNLOAD_DIR/$(basename "$CUDA_PIN_URL")"
download_resume "$CUDA_PIN_URL" "$TMP_PIN"
sudo mv "$TMP_PIN" /etc/apt/preferences.d/cuda-repository-pin-600
sudo chmod 0644 /etc/apt/preferences.d/cuda-repository-pin-600

# 2) CUDA local repo .deb 다운로드 및 등록
CUDA_DEB="$DOWNLOAD_DIR/$(basename "$CUDA_LOCAL_DEB_URL")"
download_resume "$CUDA_LOCAL_DEB_URL" "$CUDA_DEB"
sudo dpkg -i "$CUDA_DEB"

# 3) keyring 배치 (사용자 시퀀스 준수)
CUDA_LOCAL_REPO_DIR="${CUDA_LOCAL_REPO_DIR:-$CUDA_LOCAL_REPO_DIR_DEFAULT}"
[[ -d "$CUDA_LOCAL_REPO_DIR" ]] || err "로컬 리포 디렉터리를 찾을 수 없습니다: $CUDA_LOCAL_REPO_DIR"
sudo cp "$CUDA_LOCAL_REPO_DIR"/cuda-*-keyring.gpg /usr/share/keyrings/ || err "CUDA keyring 복사 실패"

# 4) apt 갱신
sudo apt-get update -y

# 5) cuda-toolkit-13-0 후보 검증 후 설치
CAND_VER="$(LC_ALL=C apt-cache policy "$CUDA_TOOLKIT_PKG" | awk -F': ' '/^  Candidate:|^Candidate:/ {print $2; exit}')"
if [[ -z "$CAND_VER" || "$CAND_VER" == "(none)" ]]; then
  echo "[ERROR] CUDA Toolkit 후보가 없습니다: $CUDA_TOOLKIT_PKG" >&2
  echo "[HINT] 사용 가능한 메타패키지 후보:" >&2
  apt-cache search -n '^cuda-toolkit-[0-9]+-[0-9]+$' | awk '{print "  - "$1}' >&2 || true
  err "CUDA Toolkit 메타패키지를 확인하고 다시 실행하세요."
fi
info "CUDA Toolkit 설치: $CUDA_TOOLKIT_PKG (candidate: $CAND_VER)"
sudo_apt_install "$CUDA_TOOLKIT_PKG"

############################################
# ========== TensorRT (pip --user + PEP668 우회) =========
############################################
info "TensorRT: pip --user (+ --break-system-packages) 로 설치합니다"
need_cmd "$PYTHON_BIN"

# pip 업그레이드 + 설치 (항상 --user, PEP668 우회)
PIP_COMMON_ARGS=(--user --break-system-packages)
"$PYTHON_BIN" -m pip install "${PIP_COMMON_ARGS[@]}" --upgrade pip wheel setuptools

if [[ -n "$TENSORRT_PIP_VERSION" ]]; then
  "$PYTHON_BIN" -m pip install "${PIP_COMMON_ARGS[@]}" "tensorrt==${TENSORRT_PIP_VERSION}"
else
  "$PYTHON_BIN" -m pip install "${PIP_COMMON_ARGS[@]}" "tensorrt"
fi


# PATH 안내 (사용자 bin 경로)
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  warn "~/.local/bin 이 PATH에 없습니다. 아래를 쉘 설정에 추가하세요:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

# 설치 검증 (현재 python에서 import 가능해야 함)
"$PYTHON_BIN" - <<'PYCHK'
import sys
try:
    import tensorrt as trt
    print(f"[VERIFY] TensorRT Python version: {trt.__version__}")
    sys.exit(0)
except Exception as e:
    print(f"[ERROR] TensorRT import failed: {e}", file=sys.stderr)
    sys.exit(1)
PYCHK

info "TensorRT(pip --user) 설치 완료"

############################################
# ======== ENV & VERIFICATION GUIDES ======
############################################
CUDA_ROOT_CANDIDATE="/usr/local/cuda"
if [[ -d "$CUDA_ROOT_CANDIDATE" ]]; then
  echo
  echo "[GUIDE] 셸 환경변수 설정(예, ~/.bashrc 또는 ~/.zshrc):"
  echo "  export CUDA_HOME=$CUDA_ROOT_CANDIDATE"
  echo '  export PATH="$CUDA_HOME/bin:$PATH"'
  echo '  export LD_LIBRARY_PATH="$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}"'
fi

echo
info "설치 검증"
if command -v nvidia-smi >/dev/null 2>&1; then nvidia-smi; else warn "nvidia-smi 없음 — 드라이버 확인 필요"; fi
if command -v nvcc >/dev/null 2>&1; then nvcc --version; else warn "nvcc 없음 — PATH/설치 구성을 확인하세요"; fi

echo
info "설치 완료 — 필요 시 재시작/재로그인을 권장합니다."
