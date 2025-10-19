#!/usr/bin/env bash
set -Eeuo pipefail
echo "==> 서비스 비활성화"
systemctl --user disable --now create-obs-virtual-mic.service create-obs-monitor-sink.service || true

echo "==> 모듈 언로드"
for id in $(pactl list short modules | awk '/module-virtual-source/ && /source_name=OBS_VirtualMic/ {print $1}'); do
  pactl unload-module "$id" || true; done
for id in $(pactl list short modules | awk '/module-null-sink/ && /sink_name=OBS_Monitor/ {print $1}'); do
  pactl unload-module "$id" || true; done

echo "==> 유닛/바이너리 삭제"
rm -f "$HOME/.config/systemd/user/create-obs-virtual-mic.service" \
      "$HOME/.config/systemd/user/create-obs-monitor-sink.service"
sudo rm -f /usr/local/bin/create-obs-virtual-mic.sh \
           /usr/local/bin/create-obs-monitor-sink.sh

echo "==> user 데몬 리로드"
systemctl --user daemon-reload

echo "==> 확인"
echo "[SINKS]";   pactl list short sinks   | grep -E 'OBS_Monitor' || true
echo "[SOURCES]"; pactl list short sources | grep -E 'OBS_VirtualMic|OBS_Monitor\.monitor' || true
echo "✅ Uninstall complete"
