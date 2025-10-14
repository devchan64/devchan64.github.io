#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] NVM + Node.js 22 설치 스크립트 시작..."

# ✅ 필요한 패키지 확인 (curl, ca-certificates)
echo "[INFO] 필수 패키지 설치 (curl, ca-certificates)"
sudo apt update -y
sudo apt install -y curl ca-certificates

# ✅ NVM 설치
if [[ -d "$HOME/.nvm" ]]; then
    echo "[INFO] NVM 이미 설치됨 - 건너뜀"
else
    echo "[INFO] NVM 설치 중..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# ✅ NVM 환경로드 (.bashrc / .zshrc 지원)
echo "[INFO] NVM 환경 로드"
if [[ -f "$HOME/.bashrc" ]]; then
    source "$HOME/.bashrc"
fi
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
fi

# 명시적으로 nvm.sh 한번 더 로드 (쉘 스크립트 호환성)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
else
    echo "[ERROR] nvm.sh 로드 실패 - 설치 확인 필요"
    exit 1
fi

# ✅ Node.js 22 설치
if nvm ls 22 >/dev/null 2>&1; then
    echo "[INFO] Node.js 22 이미 설치됨 - 건너뜀"
else
    echo "[INFO] Node.js 22 설치 중..."
    nvm install 22
fi

# ✅ default로 설정
echo "[INFO] Node.js 22를 default로 설정"
nvm alias default 22
nvm use default

# ✅ 설치 확인
echo "[INFO] Node.js 버전 확인"
node -v || { echo "[ERROR] Node 명령어 실행 실패"; exit 1; }

echo "[INFO] npm 버전 확인"
npm -v || { echo "[ERROR] npm 명령어 실행 실패"; exit 1; }

echo "------------------------------------"
echo "[완료] NVM + Node.js 22 설치 및 기본 설정 완료"
echo "터미널을 새로 열거나 다음 명령으로 즉시 적용:"
echo "  source ~/.bashrc  # or ~/.zshrc"
echo "------------------------------------"
