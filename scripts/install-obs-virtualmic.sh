#!/usr/bin/env bash
set -Eeuo pipefail
abort(){ echo "[ERROR] $*" >&2; exit 1; }
need(){ command -v "$1" >/dev/null 2>&1 || abort "필요 명령어가 없습니다: $1"; }

# 선행 체크
need systemctl; need loginctl
if ! command -v pactl >/dev/null 2>&1; then
  [[ $EUID -eq 0 ]] || abort "APT 설치가 필요합니다. sudo -i 로 다시 실행하세요."
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y --no-install-recommends pulseaudio-utils pipewire pipewire-audio pipewire-pulse wireplumber
fi

# user bus 준비(SSH/TTY 포함)
sudo loginctl enable-linger "$USER" >/dev/null
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
systemctl --user import-environment XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS || true

# PipeWire user 서비스 기동
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service

# 실행 바이너리 설치
sudo install -m 0755 /dev/stdin /usr/local/bin/create-obs-monitor-sink.sh <<'BIN1'
#!/usr/bin/env bash
set -Eeuo pipefail
command -v pactl >/dev/null || { echo "[ERROR] pactl 필요"; exit 1; }
if pactl list short sinks | awk '{print $2}' | grep -Fxq "OBS_Monitor"; then
  echo "[INFO] OBS_Monitor 이미 존재"; exit 0; fi
mid="$(pactl load-module module-null-sink sink_name=OBS_Monitor sink_properties=device.description=OBS_Monitor)" \
  || { echo "[ERROR] OBS_Monitor 생성 실패"; exit 1; }
for i in {1..5}; do pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_Monitor.monitor" && break || sleep 0.2; done
pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_Monitor.monitor" || { echo "[ERROR] OBS_Monitor.monitor 확인 실패 (module $mid)"; exit 1; }
echo "[OK] Created: OBS_Monitor + OBS_Monitor.monitor"
BIN1

sudo install -m 0755 /dev/stdin /usr/local/bin/create-obs-virtual-mic.sh <<'BIN2'
#!/usr/bin/env bash
set -Eeuo pipefail
command -v pactl >/dev/null || { echo "[ERROR] pactl 필요"; exit 1; }
pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_Monitor.monitor" \
  || { echo "[ERROR] 선행 없음: OBS_Monitor.monitor"; exit 1; }
# 중복 제거
for id in $(pactl list short modules | awk '/module-virtual-source/ && /source_name=OBS_VirtualMic/ {print $1}'); do
  pactl unload-module "$id"; done
mid="$(pactl load-module module-virtual-source source_name=OBS_VirtualMic source_properties=device.description=OBS_VirtualMic master=OBS_Monitor.monitor)" \
  || { echo "[ERROR] OBS_VirtualMic 생성 실패"; exit 1; }
for i in {1..5}; do pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_VirtualMic" && break || sleep 0.2; done
pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_VirtualMic" || { echo "[ERROR] OBS_VirtualMic 확인 실패 (module $mid)"; exit 1; }
echo "[OK] Created: OBS_VirtualMic"
BIN2

# systemd user 유닛 설치
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/create-obs-monitor-sink.service" <<'UNIT1'
[Unit]
Description=Create OBS Monitor Sink (OBS_Monitor)
After=pipewire.service wireplumber.service default.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/create-obs-monitor-sink.sh
RemainAfterExit=yes

[Install]
WantedBy=default.target
UNIT1

cat > "$HOME/.config/systemd/user/create-obs-virtual-mic.service" <<'UNIT2'
[Unit]
Description=Create OBS Virtual Mic (OBS_VirtualMic from OBS_Monitor.monitor)
After=create-obs-monitor-sink.service
Requires=create-obs-monitor-sink.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/create-obs-virtual-mic.sh
RemainAfterExit=yes

[Install]
WantedBy=default.target
UNIT2

# 적용 및 즉시 실행
systemctl --user daemon-reload
systemctl --user enable --now create-obs-monitor-sink.service
systemctl --user enable --now create-obs-virtual-mic.service

# 요약 표시
echo "[SINKS]";   pactl list short sinks   | grep -E 'OBS_Monitor' || true
echo "[SOURCES]"; pactl list short sources | grep -E 'OBS_VirtualMic|OBS_Monitor\.monitor' || true
echo
echo "OBS 설정 → 오디오 → 모니터링 장치: 'OBS_Monitor'"
echo "화상채팅 마이크 입력: 'OBS_VirtualMic'"
