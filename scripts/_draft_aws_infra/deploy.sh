#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helper.sh"

# 배포 및 삭제 순서 정의
deploy_order=("network" "elb" "ecs" "apigateway")
undeploy_order=("apigateway" "ecs" "elb" "network")

# 리소스 배포
deploy_all() {
    log "=== 전체 리소스 배포 시작 ==="
    for resource in "${deploy_order[@]}"; do
        execute_resource "$resource" deploy
    done
    log "=== 전체 리소스 배포 완료 ==="
}

# 리소스 삭제
undeploy_all() {
    log "=== 전체 리소스 삭제 시작 ==="
    for resource in "${undeploy_order[@]}"; do
        execute_resource "$resource" undeploy
    done
    log "=== 전체 리소스 삭제 완료 ==="
}

# 개별 리소스 실행
execute_resource() {
    local resource=$1
    local action=$2
    local deploy_file="$SCRIPT_DIR/deploy.${resource}.sh"

    if [[ -f "$deploy_file" ]]; then
        source "$deploy_file"
        if type "$action" &>/dev/null; then
            log "[${resource}] ${action} 시작"
            "$action" || error "[${resource}] ${action} 실패"
            log "[${resource}] ${action} 완료"
        else
            error "[${resource}]에 ${action} 함수가 정의되어 있지 않습니다."
        fi
    else
        error "[${resource}] 스크립트($deploy_file)가 존재하지 않습니다."
    fi
}

# 도움말 출력
show_help() {
    # 동적으로 리소스 목록 생성
    local resources=()
    for deploy_file in "$SCRIPT_DIR"/deploy.*.sh; do
        if [[ -f "$deploy_file" ]]; then
            resource_name=$(basename "$deploy_file" | sed -e 's/^deploy.//' -e 's/.sh$//')
            resources+=("$resource_name")
        fi
    done


    # 쉼표로 구분된 리소스 문자열 생성
    local resource_list
    resource_list=$(IFS=,; echo "${resources[*]}")

    cat <<EOF
Usage: $0 {deploy-all|undeploy-all|deploy <resource>|undeploy <resource>|help}

Commands:
  deploy-all           Deploy all resources in the following order:
                       ${deploy_order[*]}
  undeploy-all         Remove all resources in reverse order:
                       ${undeploy_order[*]}
  deploy <resource>    Deploy a specific resource. Available resources:
                       ${resource_list}
  undeploy <resource>  Remove a specific resource. Available resources:
                       ${resource_list}
  help                 Show this help message.

Details:
  - The script dynamically detects resources based on deploy-*.sh files in the script directory.
  - Each resource must have a deploy script (e.g., deploy-network.sh) with deploy and undeploy functions defined.
EOF
}
# 명령어 처리
case "$1" in
    deploy-all)
        deploy_all
        ;;
    undeploy-all)
        undeploy_all
        ;;
    deploy)
        if [[ -n "$2" ]]; then
            execute_resource "$2" deploy
        else
            error "리소스를 지정해야 합니다. 예: $0 deploy network"
        fi
        ;;
    undeploy)
        if [[ -n "$2" ]]; then
            execute_resource "$2" undeploy
        else
            error "리소스를 지정해야 합니다. 예: $0 undeploy network"
        fi
        ;;
    help)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac
