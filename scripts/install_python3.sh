#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Ubuntu Python3 설치 시작..."

# ✅ 패키지 목록 업데이트
echo "[INFO] apt update 실행"
sudo apt update -y

# ✅ Python3, pip, venv 설치
echo "[INFO] python3, pip, venv 설치"
sudo apt install -y python3 python3-pip python3-venv

# ✅ Python3 기본 확인
echo "[INFO] Python 버전 확인"
python3 --version || { echo "[ERROR] python3 명령어 실행 실패"; exit 1; }

# ✅ pip 확인
echo "[INFO] pip 버전 확인"
pip3 --version || { echo "[ERROR] pip3 명령어 실행 실패"; exit 1; }

# ✅ venv 테스트 디렉토리 생성 및 가상환경 테스트
TEST_DIR="/tmp/.venv"
echo "[INFO] 테스트용 가상환경 생성: $TEST_DIR"
rm -rf "$TEST_DIR"
python3 -m venv "$TEST_DIR"

if [[ -d "$TEST_DIR/bin" ]]; then
    echo "[INFO] 가상환경 생성 성공"
else
    echo "[ERROR] python3 -m venv 실패"
    exit 1
fi

# ✅ 완료 메시지 출력
echo "[INFO] Python3 설치 및 기본 구성 완료"

# ✅ 후처리 안내
echo "------------------------------------"
echo "사용 예:"
echo "  source $TEST_DIR/bin/activate"
echo "  python --version"
echo "  pip --version"
echo "------------------------------------"

