#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helper_functions.sh"

# ECS 리소스 배포
# ECS 및 Fargate 서비스 배포
deploy() {
  ecr_push
  add_role

  log "=== ECS 클러스터 생성 ==="
  CLUSTER_ARN=$(aws ecs create-cluster --cluster-name "${CLUSTER_NAME}" --query "cluster.clusterArn" --output text --no-paginate)
  log "ECS 클러스터 생성 완료: $CLUSTER_ARN"

  # 기존 서비스 상태 확인
  EXISTING_SERVICE_STATUS=$(aws ecs describe-services --cluster "${CLUSTER_NAME}" --services "${SERVICE_NAME}" --query "services[0].status" --output text 2>/dev/null)
  log "기존 서비스 상태: $EXISTING_SERVICE_STATUS"

  # CloudWatch Logs 로그 그룹 생성
  LOG_GROUP_NAME="/ecs/${TASK_DEFINITION}"
  log "=== CloudWatch Logs 로그 그룹 생성 ==="
  aws logs create-log-group --log-group-name "${LOG_GROUP_NAME}" --region "${REGION}" 2>/dev/null || log "로그 그룹(${LOG_GROUP_NAME})이 이미 존재합니다."
  log "CloudWatch Logs 로그 그룹 확인 완료: ${LOG_GROUP_NAME}"

  # Task Definition 업데이트
  update_task_definition

  log "=== Task Definition 등록 ==="
  aws ecs register-task-definition --cli-input-json file:///tmp/task-definition.json --no-paginate --no-cli-pager
  log "Task Definition 등록 완료"

  # VPC ID 가져오기
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text --no-paginate --no-cli-pager)

  # 서브넷 필터링
  ALL_SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME_PREFIX}-*" --query "Subnets[*].SubnetId" --output text --no-paginate)
  VALID_SUBNET_IDS=()
  for SUBNET_ID in $ALL_SUBNET_IDS; do
    SUBNET_VPC_ID=$(aws ec2 describe-subnets --subnet-ids $SUBNET_ID --query "Subnets[0].VpcId" --output text --no-paginate)
    if [[ "$SUBNET_VPC_ID" == "$VPC_ID" ]]; then
      VALID_SUBNET_IDS+=("$SUBNET_ID")
    fi
  done

  if [[ ${#VALID_SUBNET_IDS[@]} -lt 2 ]]; then
    log "Error: Fargate 서비스를 생성하려면 동일한 VPC(${VPC_ID}) 내의 최소 2개의 서브넷이 필요합니다."
    exit 1
  fi
  SUBNET_IDS_JOINED=$(
    IFS=,
    log "${VALID_SUBNET_IDS[*]}"
  )

  # 보안 그룹 확인
  SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=${SECURITY_GROUP_TAG_NAME}" --query "SecurityGroups[0].GroupId" --output text --no-paginate)
  if [[ -z "$SG_ID" || "$SG_ID" == "None" ]]; then
    log "Error: 보안 그룹(${SECURITY_GROUP_TAG_NAME}) ID를 가져올 수 없습니다."
    exit 1
  fi

  # ELB 및 Target Group 검증
  TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names "${TARGET_GROUP_NAME}" --query "TargetGroups[0].TargetGroupArn" --output text --no-paginate 2>/dev/null)
  if [[ -z "$TARGET_GROUP_ARN" ]]; then
    log "Error: Target Group(${TARGET_GROUP_NAME})를 찾을 수 없습니다. 먼저 ELB를 배포하세요."
    exit 1
  fi

  ELB_ARN=$(aws elbv2 describe-load-balancers --names "${ELB_NAME}" --query "LoadBalancers[0].LoadBalancerArn" --output text --no-paginate 2>/dev/null)
  if [[ -z "$ELB_ARN" ]]; then
    log "Error: Load Balancer(${ELB_NAME})를 찾을 수 없습니다. 먼저 ELB를 배포하세요."
    exit 1
  fi

  log "=== Fargate 서비스 생성 ==="

  set -x
  aws ecs create-service \
    --cluster "${CLUSTER_NAME}" \
    --service-name "${SERVICE_NAME}" \
    --task-definition "${TASK_DEFINITION}" \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_IDS_JOINED],securityGroups=[$SG_ID],assignPublicIp=ENABLED}" \
    --load-balancers targetGroupArn=$TARGET_GROUP_ARN,containerName=$APP_NAME,containerPort=80 \
    --desired-count 1 \
    --no-paginate \
    --no-cli-pager
  log "Fargate 서비스 생성 완료"
}

# ECS 리소스 삭제
undeploy() {
  log "=== Fargate 서비스 삭제 ==="
  aws ecs delete-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --force --no-paginate --no-cli-pager || {
    log "서비스 삭제 중 오류 발생 또는 서비스가 존재하지 않습니다."
  }
  log "Fargate 서비스 삭제 완료"

  log "=== 실행 중인 태스크 중지 ==="
  TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER_NAME --query "taskArns[0]" --output text --no-paginate --no-cli-pager)
  if [[ "$TASK_ARN" != "None" && -n "$TASK_ARN" ]]; then
    aws ecs stop-task --cluster $CLUSTER_NAME --task $TASK_ARN --no-paginate --no-cli-pager
    log "실행 중인 태스크 중지 완료: $TASK_ARN"
  else
    log "실행 중인 태스크가 없습니다."
  fi

  log "=== ECS 클러스터 삭제 ==="
  aws ecs delete-cluster --cluster $CLUSTER_NAME --no-paginate --no-cli-pager || {
    log "클러스터 삭제 중 오류 발생 또는 클러스터가 존재하지 않습니다."
  }
  log "ECS 클러스터 삭제 완료"

  log "=== CloudWatch Logs 로그 그룹 삭제 ==="
  LOG_GROUP_NAME="/ecs/${TASK_DEFINITION}"
  aws logs delete-log-group --log-group-name "${LOG_GROUP_NAME}" --no-paginate --no-cli-pager || {
    log "로그 그룹(${LOG_GROUP_NAME}) 삭제 중 오류 발생 또는 로그 그룹이 존재하지 않습니다."
  }
  log "CloudWatch Logs 로그 그룹 삭제 완료"
}

# 도움말 출력
show_help() {
    cat <<EOF
Usage: $0 {deploy|undeploy|help}

Commands:
  deploy      Create an ECS Cluster, register Task Definition, and deploy a Fargate Service.
  undeploy    Stop running tasks, remove the ECS Cluster and its resources.
  help        Show this help message.

Configuration:
  Cluster Name:     ${CLUSTER_NAME}
  Service Name:     ${SERVICE_NAME}
  Task Definition:  ${TASK_DEFINITION}
EOF
}

# 스크립트를 단독 실행할 때만 check_dependencies와 exec 실행
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  check_dependencies
  exec "$@"
fi