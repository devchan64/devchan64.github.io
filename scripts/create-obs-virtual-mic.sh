#!/usr/bin/env bash
# scripts/create-obs-virtual-mic.sh
set -Eeuo pipefail

command -v pactl >/dev/null || { echo "[ERROR] pactl 필요"; exit 1; }
pactl info >/dev/null 2>&1 || { echo "[ERROR] pactl info 실패: PipeWire/pipewire-pulse/wireplumber 또는 user-bus 미준비"; exit 1; }

# 이미 존재하면 성공으로 빠르게 종료
if pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_VirtualMic"; then
  echo "[INFO] OBS_VirtualMic 이미 존재"; exit 0
fi

# 선행: OBS_Monitor.monitor 준비 대기(최대 10초)
ready=0
for _ in {1..50}; do
  if pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_Monitor.monitor"; then
    ready=1; break
  fi
  sleep 0.2
done
[ "$ready" -eq 1 ] || { echo "[ERROR] 선행 없음/지연: OBS_Monitor.monitor"; exit 1; }

# 충돌 모듈만 정리(있다면 언로드)
for id in $(pactl list short modules | awk '/module-virtual-source/ && /source_name=OBS_VirtualMic/ {print $1}'); do
  pactl unload-module "$id"
done

mid="$(pactl load-module module-virtual-source source_name=OBS_VirtualMic source_properties=device.description=OBS_VirtualMic master=OBS_Monitor.monitor)" \
  || { echo "[ERROR] OBS_VirtualMic 생성 실패"; exit 1; }

# 생성 확인(최대 10초)
ok=0
for _ in {1..50}; do
  pactl list short sources | awk '{print $2}' | grep -Fxq "OBS_VirtualMic" && { ok=1; break; } || sleep 0.2
done
[ "$ok" -eq 1 ] || { echo "[ERROR] OBS_VirtualMic 확인 실패 (module $mid)"; exit 1; }

echo "[OK] Created: OBS_VirtualMic"
