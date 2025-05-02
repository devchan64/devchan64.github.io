#! /bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source $SCRIPT_DIR/config.sh

# set -x

# macos에서 이미지를 다운받을때 플랫폼별 이미지 다운로드가 정상적으로 이루어지지 않음
echo "macos에서 이미지를 다운받을때 플랫폼별 이미지 다운로드가 정상적으로 이루어지지 않음"
echo "node:18-alpine 이미지 다운로드"
docker pull --platform linux/amd64 node:18-alpine     

docker build --progress=plain --platform linux/amd64 -t ${REPOSITORY_NAME}:latest .
# Docker 이미지 태깅
docker tag "${REPOSITORY_NAME}:latest" "${ECR_REPO_URL}:latest"
echo "Docker 이미지 태깅 완료: ${ECR_REPO_URL}:latest"