#!/usr/bin/env bash
# install_obs_ubuntu.sh
# Ubuntu 22.04/24.04에서 OBS Studio를 APT(PPA)로 설치 (단일 경로)
# 기본 동작: OBS + obs-backgroundremoval 플러그인(.deb) 자동 설치
# 옵션:
#   --no-bgremoval    플러그인 설치 생략
#
# 사용 예:
#   chmod +x install_obs_ubuntu.sh
#   ./install_obs_ubuntu.sh                 # OBS + 플러그인 설치(기본)
#   ./install_obs_ubuntu.sh --no-bgremoval  # 플러그인 생략
#
# 정책: 엄격 에러처리, 폴백 금지

set -Eeuo pipefail

########## 공통 ##########
err() { echo "[ERROR] $*" >&2; exit 1; }
info() { echo "[INFO]  $*"; }
ok()  { echo "[OK]    $*"; }

trap 'err "실패: 라인 $LINENO에서 오류 발생"' ERR

if [[ "$(id -u)" -eq 0 ]]; then
  err "root로 직접 실행하지 마세요. 일반 사용자로 실행하세요(내부에서 sudo를 사용합니다)."
fi

# Ubuntu 버전 확인
source /etc/os-release || err "/etc/os-release 를 읽을 수 없습니다."
UBU_VER="${VERSION_ID:-}"
case "$UBU_VER" in
  22.04|24.04) ok "Ubuntu $UBU_VER 감지" ;;
  *) info "감지된 Ubuntu 버전: ${UBU_VER:-unknown}"
     info "22.04 또는 24.04에서 검증되었습니다. 계속 진행합니다."
     ;;
esac

# -------- 인자 파싱 --------
INSTALL_BGREMOVAL="1"   # 기본값: 설치함
if [[ "$#" -gt 0 ]]; then
  for arg in "$@"; do
    case "$arg" in
      --no-bgremoval) INSTALL_BGREMOVAL="0" ;;
      *)
        err "알 수 없는 옵션: $arg  (허용: --no-bgremoval)"
        ;;
    esac
  done
fi

# sudo 사전 확인
sudo -v >/dev/null

########## 함수: APT(PPA)로 OBS 설치 ##########
install_obs_via_apt() {
  info "필수 패키지 설치 및 저장소 준비"
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common curl ca-certificates

  info "OBS 공식 PPA 추가"
  sudo add-apt-repository -y ppa:obsproject/obs-studio

  info "OBS 및 관련 패키지 설치"
  sudo apt-get update -y
  sudo apt-get install -y obs-studio qtwayland5 v4l2loopback-dkms ffmpeg

  ok "OBS 설치 확인:"
  if command -v obs >/dev/null 2>&1; then
    obs --version | head -n 1
  else
    err "obs 바이너리를 찾을 수 없습니다."
  fi
}

########## 함수: obs-backgroundremoval(.deb) 설치 ##########
# - GitHub 최신 릴리스/태그에서 아키텍처에 맞는 .deb 자동 선택
# - 환경변수: PLUGIN_OWNER(기본 royshil), PLUGIN_REPO(기본 obs-backgroundremoval), PLUGIN_TAG(기본 latest)
install_obs_bgremoval_deb() {
  info "obs-backgroundremoval 최신 .deb 검색 및 설치"

  command -v obs >/dev/null 2>&1 || err "OBS가 설치되어 있지 않습니다."
  # jq 필요
  if ! command -v jq >/dev/null 2>&1; then
    info "jq 설치"
    sudo apt-get update -y
    sudo apt-get install -y jq
  fi

  local owner="${PLUGIN_OWNER:-royshil}"
  local repo="${PLUGIN_REPO:-obs-backgroundremoval}"
  local tag="${PLUGIN_TAG:-latest}"
  local arch; arch="$(dpkg --print-architecture)"; [[ "$arch" =~ ^(amd64|arm64)$ ]] || err "미지원 아키텍처: $arch"

  local api
  if [[ "$tag" == "latest" ]]; then
    api="https://api.github.com/repos/${owner}/${repo}/releases/latest"
  else
    api="https://api.github.com/repos/${owner}/${repo}/releases/tags/${tag}"
  fi

  local json; json="$(curl -fsSL "$api")" || err "GitHub API 호출 실패"
  # 아키/리눅스 키워드 우선 매칭 → 없으면 .deb 첫 항목
  local deb_url; deb_url="$(
    echo "$json" | jq -r --arg arch "$arch" '
      .assets[]?.browser_download_url
      | select(endswith(".deb"))
      | select((test($arch)) or (test("linux|ubuntu"; "i")))'
  )"
  deb_url="$(echo "$deb_url" | head -n1)"
  [[ -n "$deb_url" && "$deb_url" != "null" ]] || err ".deb 자산을 찾지 못했습니다. 저장소/태그를 확인하세요."

  # _apt가 접근 가능한 디렉터리(755)와 파일(644) 보장
  local tmpd deb_file
  tmpd="$(mktemp -d -p /var/tmp obsbgremoval.XXXXXX)"
  chmod 755 "$tmpd"
  trap 'rm -rf "$tmpd"' RETURN

  pushd "$tmpd" >/dev/null
  info "다운로드: $deb_url"
  curl -fLO "$deb_url"

  deb_file="$(ls *.deb | head -n1)"
  [[ -f "$deb_file" ]] || err ".deb 파일이 존재하지 않습니다."
  chmod 644 "$deb_file"

  info "패키지 설치: $deb_file"
  sudo apt-get update -y
  # 절대경로로 전달해 _apt가 직접 읽게 함
  sudo apt-get install -y "$PWD/$deb_file"
  popd >/dev/null

  dpkg -L obs-backgroundremoval 2>/dev/null | grep -qE '\.so$' \
    || err "설치 검증 실패: obs-backgroundremoval .so가 확인되지 않음"

  ok "플러그인 설치 완료: obs-backgroundremoval"
  info "경로 확인: dpkg -L obs-backgroundremoval | grep -E '\\.so$'"
}

########## GPU/Wayland 힌트 ##########
post_gpu_tips() {
  echo
  info "GPU 인코딩/오디오 관련 안내"
  if command -v nvidia-smi >/dev/null 2>&1; then
    ok "NVIDIA GPU 감지됨:"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader || true
    echo " - NVENC 사용은 ffmpeg/OBS 빌드에 포함되어 있어야 합니다."
  fi

  if lspci | grep -i 'VGA\|3D' | grep -iq 'AMD'; then
    ok "AMD GPU 감지됨(가능 시 VAAPI 사용)"
    echo " - VAAPI 사용을 위해 /dev/dri 권한 및 mesa VA-API 드라이버가 필요할 수 있습니다."
    echo "   패키지 예: mesa-va-drivers, libva-drm2, libva2"
  fi

  echo
  echo "Wayland 환경 권장:"
  echo " - xdg-desktop-portal, xdg-desktop-portal-gnome/gtk, pipewire, wireplumber 최신화"
  echo " - 화면 캡처는 'PipeWire (Wayland)' 소스를 사용"
}

########## 실행 ##########
install_obs_via_apt

if [[ "$INSTALL_BGREMOVAL" == "1" ]]; then
  install_obs_bgremoval_deb
else
  info "요청에 따라 obs-backgroundremoval 설치를 생략합니다."
fi

post_gpu_tips

ok "설치 스크립트 완료"
echo "---------------------------------------------"
echo "실행: obs"
echo "플러그인: obs-backgroundremoval (기본 설치됨; --no-bgremoval 로 생략 가능)"
echo "---------------------------------------------"
