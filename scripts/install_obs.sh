#!/usr/bin/env bash
# install_obs_ubuntu.sh
# Ubuntu 22.04/24.04에서 OBS Studio 설치 스크립트
# 기본: Flatpak 설치. 옵션: --apt, --flatpak, --both
# 사용법:
#   chmod +x install_obs_ubuntu.sh
#   ./install_obs_ubuntu.sh             # Flatpak 설치(권장)
#   ./install_obs_ubuntu.sh --apt       # APT(PPA) 설치
#   ./install_obs_ubuntu.sh --both      # Flatpak + APT 동시 설치
#   ./install_obs_ubuntu.sh --flatpak   # Flatpak만 명시적 설치
#
# 주의: 본 스크립트는 오류 발생 시 즉시 종료합니다.

set -Eeuo pipefail

########## 공통 ##########
err() { echo "[ERROR] $*" >&2; exit 1; }
info() { echo "[INFO]  $*"; }
ok() { echo "[OK]    $*"; }

trap 'err "실패: 라인 $LINENO에서 오류 발생"' ERR

if [[ "$(id -u)" -eq 0 ]]; then
  err "root로 직접 실행하지 마세요. 일반 사용자로 실행하세요(내부에서 sudo를 사용합니다)."
fi

# Ubuntu 버전 체크 (22.04 이상 권장)
source /etc/os-release || err "/etc/os-release 를 읽을 수 없습니다."
UBU_VER="${VERSION_ID:-}"
case "$UBU_VER" in
  22.04|24.04) ok "Ubuntu $UBU_VER 감지" ;;
  *) info "감지된 Ubuntu 버전: ${UBU_VER:-unknown}"
     info "22.04 또는 24.04에서 검증되었습니다. 계속 진행합니다."
     ;;
esac

# 모드 파싱
MODE="${1:-flatpak}"
case "$MODE" in
  --flatpak|flatpak) MODE="flatpak" ;;
  --apt|apt) MODE="apt" ;;
  --both|both) MODE="both" ;;
  *) err "알 수 없는 옵션: $MODE  (허용: --flatpak | --apt | --both)" ;;
esac

# sudo 가능 여부 사전 확인
sudo -v >/dev/null

########## 함수: Flatpak 설치 ##########
install_flatpak_obs() {
  info "Flatpak 및 Flathub 설정"
  sudo apt-get update -y
  sudo apt-get install -y flatpak || err "flatpak 설치 실패"
  # GNOME 환경에서 소프트웨어 센터 통합(선택적이지만 있으면 편함)
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y gnome-software-plugin-flatpak || true
  fi
  if ! flatpak remote-list | awk '{print $1}' | grep -q "^flathub$"; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ok "Flathub 등록 완료"
  else
    ok "Flathub 이미 등록됨"
  fi

  info "OBS Studio(Flatpak) 설치"
  flatpak install -y flathub com.obsproject.Studio

  ok "Flatpak OBS 설치 확인:"
  flatpak info com.obsproject.Studio | sed -n '1,12p' || err "Flatpak OBS 정보 조회 실패"
  echo
  info "실행 방법: flatpak run com.obsproject.Studio"
}

########## 함수: APT(PPA) 설치 ##########
install_apt_obs() {
  info "필수 구성요소 업데이트"
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common curl ca-certificates || err "기본 패키지 설치 실패"

  info "OBS 공식 PPA 추가"
  sudo add-apt-repository -y ppa:obsproject/obs-studio

  info "패키지 목록 갱신 및 OBS 설치"
  sudo apt-get update -y
  # Wayland 사용 시 Qt Wayland 모듈 설치 권장
  sudo apt-get install -y obs-studio qtwayland5

  # 유용한 추가 패키지
  # - v4l2loopback-dkms: OBS 가상 카메라(커널 모듈)
  # - ffmpeg: 인코더/디코더
  # - pipewire-jack/jackd2: 오디오 라우팅 시 활용(선택)
  sudo apt-get install -y v4l2loopback-dkms ffmpeg

  ok "APT OBS 설치 확인:"
  if command -v obs >/dev/null 2>&1; then
    obs --version | head -n 1
  else
    err "obs 바이너리를 찾을 수 없습니다."
  fi
  echo
  info "실행 방법: obs"
}

########## GPU/NVENC 힌트 ##########
post_gpu_tips() {
  echo
  info "GPU 인코딩/오디오 관련 안내"
  # NVIDIA 감지
  if command -v nvidia-smi >/dev/null 2>&1; then
    ok "NVIDIA GPU 감지됨:"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader || true
    echo " - NVENC 사용은 ffmpeg/OBS 빌드에 포함되어 있어야 합니다."
  fi

  # AMD VAAPI 힌트
  if lspci | grep -i 'VGA\|3D' | grep -iq 'AMD'; then
    ok "AMD GPU 감지됨(가능 시 VAAPI 사용)"
    echo " - VAAPI 사용을 위해 /dev/dri 권한 및 mesa VA-API 드라이버가 필요할 수 있습니다."
    echo "   패키지 예: mesa-va-drivers, libva-drm2, libva2"
  fi

  # Wayland 힌트
  echo
  echo "Wayland 환경에서는 다음을 권장합니다:"
  echo " - 파이프와이어/포털 최신화: xdg-desktop-portal, xdg-desktop-portal-gtk(or -gnome), pipewire, wireplumber"
  echo " - 화면 캡처는 'PipeWire (Wayland)' 소스를 사용하세요."
}

########## 실행 ##########
case "$MODE" in
  flatpak)
    install_flatpak_obs
    ;;
  apt)
    install_apt_obs
    ;;
  both)
    install_flatpak_obs
    install_apt_obs
    ;;
esac

post_gpu_tips

ok "설치 스크립트 완료"
echo "---------------------------------------------"
echo "Flatpak 실행: flatpak run com.obsproject.Studio"
echo "APT 실행    : obs"
echo "---------------------------------------------"
