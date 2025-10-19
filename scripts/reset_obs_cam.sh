#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Resetting v4l2loopback virtual camera..."
sudo modprobe -r v4l2loopback || true
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1

echo "[INFO] Done. Launching OBS..."