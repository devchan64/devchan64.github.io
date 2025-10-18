#!/usr/bin/env bash
set -euo pipefail

GITHUB_HOST="${GITHUB_HOST:-github.com}"

echo "[INFO] GitHub CLI 웹 로그인 설정 시작 (host=${GITHUB_HOST})"

# ✅ 1) 필수 패키지 설치
echo "[INFO] 필수 패키지 설치 중..."
sudo apt update -y
sudo apt install -y curl ca-certificates git gh

# ✅ 2) gh 설치 확인
if ! command -v gh >/dev/null 2>&1; then
  echo "[ERROR] gh 명령을 찾을 수 없습니다. 설치 실패"
  exit 1
fi

# ✅ 3) GitHub CLI 로그인 상태 확인
set +e
gh auth status --hostname "${GITHUB_HOST}" >/dev/null 2>&1
AUTH_STATUS=$?
set -e

if [[ $AUTH_STATUS -ne 0 ]]; then
  echo "[INFO] 아직 GitHub 로그인되지 않았습니다. 웹 브라우저를 통해 로그인합니다."
  # 브라우저 자동 실행을 막고, 콘솔에 장치 코드 + URL을 출력하게 함
  GH_BROWSER=none BROWSER=none gh auth login \
    --hostname "${GITHUB_HOST}" \
    --git-protocol https \
    --web

else
  echo "[INFO] 이미 로그인된 상태입니다."
fi

# ✅ 4) git credential helper 설정
echo "[INFO] git credential 관리 설정"
gh auth setup-git --hostname "${GITHUB_HOST}"

# ✅ 5) 사용자 입력 기반으로 Git 전역 유저 정보 설정
echo -n "[INPUT] Git user.name 을 입력하세요: "
read -r INPUT_NAME

echo -n "[INPUT] Git user.email 을 입력하세요: "
read -r INPUT_EMAIL

if [[ -z "$INPUT_NAME" || -z "$INPUT_EMAIL" ]]; then
  echo "[ERROR] user.name 또는 user.email 이 비어 있습니다. 다시 실행해주세요."
  exit 1
fi

git config --global user.name "$INPUT_NAME"
git config --global user.email "$INPUT_EMAIL"

echo "[INFO] git user.name = $(git config --global user.name)"
echo "[INFO] git user.email = $(git config --global user.email)"

# ✅ 6) 최종 상태 출력
echo "------------------------------------"
echo "[INFO] GitHub CLI 인증 상태 확인:"
gh auth status --hostname "${GITHUB_HOST}"
echo "------------------------------------"
echo "[완료] GitHub CLI 로그인 + Git 사용자 정보 설정이 완료되었습니다."
echo "원격 테스트 예시:"
echo "  git ls-remote https://${GITHUB_HOST}/<owner>/<repo>.git"
echo "------------------------------------"
