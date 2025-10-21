#!/usr/bin/env bash
# scripts/install-obs-virtualmic.sh
# 목적:
#   - 반드시 sudo(루트)로 실행. 비-sudo 실행 시 즉시 종료.
#   - 이미 준비된 아래 4개 파일을 "재사용"하여 설치/적용 (존재하면 재사용, 자동 덮어쓰기 없음)
#       1) create-obs-monitor-sink.sh
#       2) create-obs-virtual-mic.sh
#       3) create-obs-monitor-sink.service
#       4) create-obs-virtual-mic.service
#   - systemd --user 및 pactl 관련 작업은 실제 로그인 사용자(TARGET_USER) 컨텍스트에서 수행

set -Eeuo pipefail

abort(){ echo "[ERROR] $*" >&2; exit 1; }
need(){ command -v "$1" >/dev/null 2>&1 || abort "필요 명령어가 없습니다: $1"; }
have(){ command -v "$1" >/dev/null 2>&1; }

# 0) sudo(루트) 강제
[ "${EUID:-$(id -u)}" -eq 0 ] || abort "sudo로 실행해야 합니다. 예) sudo ./install-obs-virtualmic.sh"

# 1) 대상 사용자 판별
TARGET_USER="${SUDO_USER:-}"
if [ -z "$TARGET_USER" ]; then
  if LOGNM="$(logname 2>/dev/null)"; then TARGET_USER="$LOGNM"; fi
fi
[ -n "$TARGET_USER" ] || abort "대상 사용자 식별 실패(SUDO_USER/logname). sudo로 실행했는지 확인하세요."
TARGET_UID="$(id -u "$TARGET_USER")" || abort "사용자 조회 실패: $TARGET_USER"
TARGET_HOME="$(eval echo "~$TARGET_USER")" || abort "홈 디렉터리 조회 실패: ~$TARGET_USER"

# 2) 소스/대상 경로
readonly SRC_DIR="${SRC_DIR:-$PWD}"
readonly SRC_SH_MON="$SRC_DIR/create-obs-monitor-sink.sh"
readonly SRC_SH_VMIC="$SRC_DIR/create-obs-virtual-mic.sh"
readonly SRC_SVC_MON="$SRC_DIR/create-obs-monitor-sink.service"
readonly SRC_SVC_VMIC="$SRC_DIR/create-obs-virtual-mic.service"

readonly DEST_SH_MON="/usr/local/bin/create-obs-monitor-sink.sh"
readonly DEST_SH_VMIC="/usr/local/bin/create-obs-virtual-mic.sh"
readonly USER_SYSTEMD_DIR="$TARGET_HOME/.config/systemd/user"
readonly DEST_SVC_MON="$USER_SYSTEMD_DIR/create-obs-monitor-sink.service"
readonly DEST_SVC_VMIC="$USER_SYSTEMD_DIR/create-obs-virtual-mic.service"

# 3) 필요 명령 확인
need systemctl
need loginctl
need install

# 4) 소스 파일 존재 확인
for f in "$SRC_SH_MON" "$SRC_SH_VMIC" "$SRC_SVC_MON" "$SRC_SVC_VMIC"; do
  [[ -f "$f" ]] || abort "소스 파일이 없습니다: $f"
done

# 5) pactl 준비(없으면 설치)
if ! have pactl; then
  echo "[INFO] pactl이 없어 패키지 설치를 진행합니다 (apt-get)"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y --no-install-recommends pulseaudio-utils pipewire pipewire-audio pipewire-pulse wireplumber
fi

# 6) TARGET_USER용 user-bus 환경 준비
echo "[INFO] 사용자 버스 환경 구성(linger 활성화): $TARGET_USER"
loginctl enable-linger "$TARGET_USER" >/dev/null

# TARGET_USER의 user-bus 환경 변수 산출
TARGET_XDG_RUNTIME_DIR="/run/user/${TARGET_UID}"
TARGET_DBUS_ADDR="unix:path=${TARGET_XDG_RUNTIME_DIR}/bus"

# 런타임 디렉터리/버스 존재성 검사 (없으면 종료)
[ -d "$TARGET_XDG_RUNTIME_DIR" ] || abort "XDG_RUNTIME_DIR 없음: $TARGET_XDG_RUNTIME_DIR (사용자가 로그인 세션을 가져야 합니다)"
[ -S "${TARGET_XDG_RUNTIME_DIR}/bus" ] || abort "DBUS 세션 버스 소켓 없음: ${TARGET_XDG_RUNTIME_DIR}/bus"

# runuser 헬퍼: TARGET_USER 컨텍스트에서 명령 실행(+필요 환경 주입, PATH 보강)
USER_PATH="/usr/local/bin:/usr/bin:/bin"
su_user() {
  runuser -u "$TARGET_USER" -- env \
    PATH="$USER_PATH" \
    XDG_RUNTIME_DIR="$TARGET_XDG_RUNTIME_DIR" \
    DBUS_SESSION_BUS_ADDRESS="$TARGET_DBUS_ADDR" \
    "$@"
}

# 7) PipeWire/WirePlumber 사용자 서비스 활성화(TARGET_USER 컨텍스트)
echo "[INFO] PipeWire/WirePlumber 사용자 서비스 활성화 (user: $TARGET_USER)"
su_user systemctl --user import-environment XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS || true
su_user systemctl --user enable --now pipewire.service
su_user systemctl --user enable --now pipewire-pulse.service
su_user systemctl --user enable --now wireplumber.service

# 8) 스크립트 설치(/usr/local/bin) — 존재하면 재사용, 없으면 설치
install_if_absent() {
  local src="$1" dest="$2" mode="$3"
  if [[ -e "$dest" ]]; then
    echo "[REUSE] $dest 이미 존재 → 재사용"
    return 0
  fi
  install -m "$mode" "$src" "$dest"
  echo "[OK] 설치: $dest"
}
install_if_absent "$SRC_SH_MON"  "$DEST_SH_MON"  0755
install_if_absent "$SRC_SH_VMIC" "$DEST_SH_VMIC" 0755

# 9) systemd user 유닛 설치(~TARGET_USER/.config/systemd/user) — 존재하면 재사용
mkdir -p "$USER_SYSTEMD_DIR"
chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME/.config" || abort "권한 설정 실패: $TARGET_HOME/.config"

install_if_absent "$SRC_SVC_MON"  "$DEST_SVC_MON"  0644
install_if_absent "$SRC_SVC_VMIC" "$DEST_SVC_VMIC" 0644
chown "$TARGET_USER":"$TARGET_USER" "$DEST_SVC_MON" "$DEST_SVC_VMIC" || abort "권한 설정 실패: service files"

# 10) 적용 및 즉시 실행 (TARGET_USER 컨텍스트)
echo "[INFO] systemd --user daemon-reload 및 유닛 활성화 (user: $TARGET_USER)"
su_user systemctl --user daemon-reload
su_user systemctl --user enable --now create-obs-monitor-sink.service
su_user systemctl --user enable --now create-obs-virtual-mic.service

# 11) 결과 요약 (TARGET_USER의 pactl)
echo "[SINKS]"
su_user pactl list short sinks   | grep -E 'OBS_Monitor' || true
echo "[SOURCES]"
su_user pactl list short sources | grep -E '(^|output\.)OBS_VirtualMic$|^OBS_Monitor\.monitor$' || true

echo
echo "OBS 설정 → 오디오 → 모니터링 장치: 'OBS_Monitor'"
echo "화상채팅 마이크 입력: 'OBS_VirtualMic' (PipeWire에선 'output.OBS_VirtualMic'로 보일 수 있음)"

echo "[DONE] 재사용 기반 설치 완료 (user: $TARGET_USER, uid: $TARGET_UID)"
