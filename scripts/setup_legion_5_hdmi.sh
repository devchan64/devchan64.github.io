#!/usr/bin/env bash
# Legion 5 HDMI setup for Ubuntu 24.04 (Xorg + NVIDIA open kernel driver)
# - PRIME auto-switch to nvidia (reboot required → exit 5)
# - External (HDMI/DP) primary, prefer 165Hz if available
# - Robust xrandr parsing (no silent fallbacks)

set -Eeuo pipefail
set -o errtrace
trap 'echo "[ERR] line:${LINENO} cmd:${BASH_COMMAND:-}" >&2; exit 1' ERR

usage() {
  cat <<'USAGE'
Usage:
  setup-legion-5-hdmi.sh
    [--layout right|left|mirror|external-only]
    [--rate 165]
    [--dpms-off]
    [--no-switch-prime]
    [--enable-prime-sync]
    [--verbose]
USAGE
}

# ----- Legion 5 defaults -----
LAYOUT="${LAYOUT_OVERRIDE:-right}";            # right|left|mirror|external-only
REQ_RATE="${RATE_OVERRIDE:-165}";              # prefer 165Hz; if unsupported, use preferred(+)
DPMS_OFF="${DPMS_OFF_OVERRIDE:-1}";            # 1 = disable DPMS/screensaver
SWITCH_PRIME="${SWITCH_PRIME_OVERRIDE:-1}";    # 1 = auto switch to nvidia
ENABLE_PRIME_SYNC="${PRIME_SYNC_OVERRIDE:-1}"; # 1 = try enabling PRIME Sync
VERBOSE="${VERBOSE_OVERRIDE:-0}";

# ----- CLI overrides -----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --layout)            LAYOUT="${2:?}"; shift 2;;
    --rate)              REQ_RATE="${2:?}"; shift 2;;
    --dpms-off)          DPMS_OFF="1"; shift;;
    --no-switch-prime)   SWITCH_PRIME="0"; shift;;
    --enable-prime-sync) ENABLE_PRIME_SYNC="1"; shift;;
    --verbose)           VERBOSE="1"; shift;;
    -h|--help)           usage; exit 0;;
    *) echo "[ERR] Unknown arg: $1"; usage; exit 1;;
  esac
done

log() { if [ "${VERBOSE:-0}" = "1" ]; then echo "[INFO]" "$@"; fi; }

# ----- Preconditions -----
if [ "${XDG_SESSION_TYPE:-}" != "x11" ]; then
  echo "[ERR] Requires Xorg (x11). Current: ${XDG_SESSION_TYPE:-unknown}" >&2; exit 3
fi
for c in xrandr prime-select; do command -v "$c" >/dev/null || { echo "[ERR] '$c' not found"; exit 1; }; done
export __GLX_VENDOR_LIBRARY_NAME="nvidia"

# PRIME must be nvidia
CURRENT_PRIME="$(prime-select query || true)"
if [ "${CURRENT_PRIME:-}" != "nvidia" ]; then
  if [ "${SWITCH_PRIME:-1}" = "1" ]; then
    echo "[ACT] Switching PRIME to 'nvidia' (sudo prime-select nvidia)"
    sudo prime-select nvidia
    echo "[NEED REBOOT] PRIME switched to 'nvidia'. Reboot, then rerun this script."
    exit 5
  else
    echo "[ERR] PRIME is '${CURRENT_PRIME:-unset}'. Re-run without --no-switch-prime or set manually."; exit 1
  fi
fi

# NVIDIA provider present?
if ! xrandr --listproviders | grep -qi 'NVIDIA'; then
  echo "[ERR] NVIDIA provider not detected. Ensure nvidia-driver-580-open is installed/loaded." >&2; exit 4
fi

# ----- Detect outputs -----
XR="$(xrandr --query)"
INTERNAL="$(printf '%s\n' "$XR" | awk '/^eDP[-0-9]*[[:space:]]+connected/{print $1; exit}')"
if [ -z "${INTERNAL:-}" ]; then
  echo "[ERR] Internal (eDP) output not found or disconnected."; exit 1
fi

declare -a EXTS=()
# 정확히 "connected" 만 추출하고 eDP 제외
mapfile -t EXTS < <(printf '%s\n' "$XR" | awk '
  /^(HDMI|DP)(-[0-9]+)?[[:space:]]+connected/ {print $1}')
EXTS=($(printf "%s\n" "${EXTS[@]}" | grep -v "^${INTERNAL}\$" || true))
if [ ${#EXTS[@]} -eq 0 ]; then
  echo "[ERR] No external HDMI/DP connected."
  exit 2
fi
EXT="${EXTS[0]}"; log "Internal: $INTERNAL, External: $EXT"

# ----- Robust external block extraction -----
# 시작:  "^$EXT[[:space:]]+connected"
# 종료:  "다음 출력 헤더(맨 앞 공백이 아닌 라인)"에서 블록 종료
EXT_BLOCK="$(printf '%s\n' "$XR" | awk -v ext="$EXT" '
  $1==ext && $2=="connected" {blk=1; next}
  blk && $0 !~ /^[[:space:]]/ {exit}
  blk {print}
')"
if [ -z "${EXT_BLOCK:-}" ]; then
  echo "[ERR] Cannot read mode list for $EXT"; exit 1
fi

# 외부 출력 모드 목록만
mapfile -t EXT_MODES < <(printf '%s\n' "$EXT_BLOCK" | awk '/^[[:space:]]+[0-9]+x[0-9]+/ {print $1}')
if [ ${#EXT_MODES[@]} -eq 0 ]; then
  echo "[ERR] No numeric modes found for $EXT"; printf '%s\n' "$EXT_BLOCK" >&2; exit 1
fi
if [ "${VERBOSE:-0}" = "1" ]; then
  echo "[INFO] $EXT available modes:"; printf '  %s\n' "${EXT_MODES[@]}"
fi

# preferred(+) 모드
PREFERRED_MODE="$(printf '%s\n' "$EXT_BLOCK" | awk '/^[[:space:]]+[0-9]+x[0-9]+/ && /\+/{print $1; exit}')"
if [ -z "${PREFERRED_MODE:-}" ]; then
  PREFERRED_MODE="${EXT_MODES[0]}"
  log "No (+) preferred mark; using first mode: $PREFERRED_MODE"
else
  log "Preferred(+) mode: $PREFERRED_MODE"
fi

# 선택 모드/주사율 결정
SELECTED_MODE="$PREFERRED_MODE"; SELECTED_RATE=""
if [ -n "${REQ_RATE:-}" ]; then
  RATE_RE="$(printf ' %s\\.00| %s( |$)' "$REQ_RATE" "$REQ_RATE")"
  ML="$(printf '%s\n' "$EXT_BLOCK" | grep -E "$RATE_RE" | awk '/^[[:space:]]+[0-9]+x[0-9]+/ {print $1; exit}' || true)"
  if [ -n "${ML:-}" ]; then
    SELECTED_MODE="$ML"; SELECTED_RATE="$REQ_RATE"
    log "Found ${REQ_RATE}Hz: mode=$SELECTED_MODE"
  else
    log "Requested ${REQ_RATE}Hz not found; using preferred: $PREFERRED_MODE"
  fi
fi

# 최종 검증: 선택 모드가 실제 EXTERNAL 모드 목록에 존재?
if ! printf '%s\n' "${EXT_MODES[@]}" | grep -qx "$SELECTED_MODE"; then
  echo "[ERR] Mode '$SELECTED_MODE' not available on $EXT"
  echo "[HINT] Available modes on $EXT:"; printf '  %s\n' "${EXT_MODES[@]}"
  exit 1
fi

# ----- Apply layout -----
case "$LAYOUT" in
  right)
    xrandr --output "$EXT" --mode "$SELECTED_MODE" ${SELECTED_RATE:+--rate "$SELECTED_RATE"} --primary
    xrandr --output "$INTERNAL" --auto --left-of "$EXT"
    ;;
  left)
    xrandr --output "$EXT" --mode "$SELECTED_MODE" ${SELECTED_RATE:+--rate "$SELECTED_RATE"} --primary
    xrandr --output "$INTERNAL" --auto --right-of "$EXT"
    ;;
  mirror)
    if ! xrandr --output "$INTERNAL" --mode "$SELECTED_MODE"; then
      echo "[ERR] Cannot mirror: $SELECTED_MODE unsupported on $INTERNAL"; exit 1
    fi
    xrandr --output "$EXT" --mode "$SELECTED_MODE" ${SELECTED_RATE:+--rate "$SELECTED_RATE"} --primary
    xrandr --output "$INTERNAL" --same-as "$EXT"
    ;;
  external-only)
    xrandr --output "$INTERNAL" --off
    xrandr --output "$EXT" --mode "$SELECTED_MODE" ${SELECTED_RATE:+--rate "$SELECTED_RATE"} --primary
    ;;
  *)
    echo "[ERR] Unknown --layout value: $LAYOUT"; exit 1;;
esac

# ----- PRIME Sync -----
if [ "${ENABLE_PRIME_SYNC:-0}" = "1" ]; then
  if xrandr --prop | grep -q "PRIME Synchronization"; then
    xrandr --output "$INTERNAL" --set "PRIME Synchronization" 1 2>/dev/null || echo "[WARN] PRIME Sync on $INTERNAL failed"
    xrandr --output "$EXT"      --set "PRIME Synchronization" 1 2>/dev/null || echo "[WARN] PRIME Sync on $EXT failed"
  else
    echo "[WARN] 'PRIME Synchronization' not exposed; consider kernel param: nvidia-drm.modeset=1"
  fi
fi

# ----- DPMS -----
if [ "${DPMS_OFF:-0}" = "1" ]; then
  command -v xset >/dev/null || { echo "[ERR] xset not found for --dpms-off"; exit 1; }
  xset -dpms
  xset s off
fi

echo "[OK] layout=${LAYOUT}, ext=${EXT}, mode=${SELECTED_MODE}${SELECTED_RATE:+ @${SELECTED_RATE}Hz}, dpms_off=${DPMS_OFF}, prime_sync=${ENABLE_PRIME_SYNC}"
xrandr --listmonitors
