#!/bin/bash
# 공통 함수 정의

check_dependencies() {
    echo "=== 의존성 확인 ==="
    local dependencies=("aws" "jq")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "Error: $dep가 설치되어 있지 않습니다. 설치 후 다시 시도하세요."
            exit 1
        fi
    done
    echo "=== 모든 의존성이 충족되었습니다. ==="
}

log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

exec() {
    # 명령 처리
    case "$1" in
    deploy)
        deploy
        ;;
    undeploy)
        undeploy
        ;;
    help)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
    esac
}
