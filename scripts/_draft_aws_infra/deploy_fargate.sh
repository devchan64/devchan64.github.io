#!/bin/bash

# 공통 설정
PREFIX=
REGION="ap-northeast-2"
ACCOUNT_ID=

# 리소스 이름
APP_NAME="${PREFIX}-app"
REPOSITORY_NAME="${PREFIX}-repo"
CLUSTER_NAME="${PREFIX}-cluster"
SERVICE_NAME="${PREFIX}-service"
TASK_DEFINITION="${PREFIX}-task"
ELB_NAME="${PREFIX}-elb"
TARGET_GROUP_NAME="${PREFIX}-target-group"
API_NAME="${PREFIX}-api"
VPC_NAME="${PREFIX}-vpc"
SUBNET_NAME_PREFIX="${PREFIX}-public-subnet"
SECURITY_GROUP_TAG_NAME="${PREFIX}-security-group"
ROUTE_TABLE_TAG_NAME="${PREFIX}-route-table"
STAGE_NAME="prod"

# JSON 템플릿 파일 경로
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SOURCE_FILE="${SCRIPT_DIR}/task-definition-template.json"
TARGET_FILE="/tmp/task-definition.json"

# ECR 리포지토리 URL
ECR_REPO_URL="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}"

# 의존성 확인 함수
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

# Task Definition 업데이트 함수
update_task_definition() {
  echo "=== Task Definition 업데이트 ==="
  
  # 파일이 존재하는지 확인
  if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "Error: Task definition 템플릿 파일($SOURCE_FILE)이 존재하지 않습니다."
    exit 1
  fi

  # JSON 템플릿 복사 및 수정
  cp "$SOURCE_FILE" "$TARGET_FILE"
  echo "Task definition 템플릿 복사 완료: $TARGET_FILE"

  # OS에 따라 sed 명령 처리
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' \
      -e "s|<TASK_DEFINITION>|$TASK_DEFINITION|g" \
      -e "s|<APP_NAME>|$APP_NAME|g" \
      -e "s|<ACCOUNT_ID>|$ACCOUNT_ID|g" \
      -e "s|<REGION>|$REGION|g" \
      -e "s|<REPOSITORY_NAME>|$REPOSITORY_NAME|g" \
      "$TARGET_FILE"
  else
    sed -i \
      -e "s|<TASK_DEFINITION>|$TASK_DEFINITION|g" \
      -e "s|<APP_NAME>|$APP_NAME|g" \
      -e "s|<ACCOUNT_ID>|$ACCOUNT_ID|g" \
      -e "s|<REGION>|$REGION|g" \
      -e "s|<REPOSITORY_NAME>|$REPOSITORY_NAME|g" \
      "$TARGET_FILE"
  fi

  echo "Task Definition 업데이트 완료: $TARGET_FILE"
}

ecr_push() {
  echo "=== ECR 푸시 ==="
  
  # ECR 리포지토리 확인 또는 생성
  aws ecr describe-repositories --repository-names "${REPOSITORY_NAME}" --region "${REGION}" 2>/dev/null || \
  aws ecr create-repository --repository-name "${REPOSITORY_NAME}" --region "${REGION}"
  echo "ECR 리포지토리 확인 완료: ${REPOSITORY_NAME}"

  # ECR 로그인
  aws ecr get-login-password --region "${REGION}" | docker login --username AWS --password-stdin "${ECR_REPO_URL}"
  echo "ECR 로그인 완료"

  # Docker 이미지 태그 지정 및 푸시
  docker tag "${APP_IMAGE}:latest" "${ECR_REPO_URL}:latest"
  docker push "${ECR_REPO_URL}:latest"
  echo "Docker 이미지 푸시 완료: ${ECR_REPO_URL}:latest"
}

update_ecs() {
  ecr_push

  echo "=== Task Definition 업데이트 ==="
  update_task_definition

  echo "=== Task Definition 등록 ==="
  aws ecs register-task-definition --cli-input-json file:///tmp/task-definition.json --no-paginate --no-cli-pager
  echo "Task Definition 등록 완료"

  # Task Definition 수정
  NEW_TASK_DEFINITION=$(jq -r '.family' /tmp/task-definition.json)
  echo "새 Task Definition 이름: $NEW_TASK_DEFINITION"

  echo "=== ECS 서비스 업데이트 ==="
  aws ecs update-service \
    --cluster "${CLUSTER_NAME}" \
    --service "${SERVICE_NAME}" \
    --task-definition "${NEW_TASK_DEFINITION}" \
    --desired-count 1 \
    --no-paginate \
    --no-cli-pager
  echo "ECS 서비스 업데이트 완료"

  echo "=== ECS 서비스 상태 확인 ==="
  aws ecs describe-services \
    --cluster "${CLUSTER_NAME}" \
    --services "${SERVICE_NAME}" \
    --query "services[0].deployments" \
    --output table \
    --no-paginate \
    --no-cli-pager
  echo "서비스 업데이트가 성공적으로 완료되었습니다."
}

# 네트워크 리소스 배포
deploy_network() {
  echo "=== VPC 생성 ==="
  VPC_JSON=$(aws ec2 create-vpc --cidr-block "10.0.0.0/16")
  VPC_ID=$(echo "$VPC_JSON" | jq -r '.Vpc.VpcId')
  echo "$VPC_JSON" | jq
  aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value="${VPC_NAME}"
  echo "VPC 생성 완료: $VPC_ID"

  echo "=== 인터넷 게이트웨이 생성 및 연결 ==="
  IGW_JSON=$(aws ec2 create-internet-gateway)
  IGW_ID=$(echo "$IGW_JSON" | jq -r '.InternetGateway.InternetGatewayId')
  echo "$IGW_JSON" | jq
  aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id "$IGW_ID"
  echo "인터넷 게이트웨이 생성 및 연결 완료: $IGW_ID"

  echo "=== 기본 라우팅 테이블 수정 ==="
  ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.main,Values=true" --query "RouteTables[0].RouteTableId" --output text)
  aws ec2 create-route --route-table-id "$ROUTE_TABLE_ID" --destination-cidr-block "0.0.0.0/0" --gateway-id "$IGW_ID"
  echo "기본 라우팅 테이블($ROUTE_TABLE_ID)에 IGW 경로 추가 완료"

  # 기본 라우팅 테이블에 태그 추가
  aws ec2 create-tags --resources "$ROUTE_TABLE_ID" --tags Key=Name,Value="${ROUTE_TABLE_TAG_NAME}"
  echo "기본 라우팅 테이블 태그 추가 완료"

  echo "=== 퍼블릭 서브넷 생성 ==="
  SUBNET_IDS=()
  for i in 1 2; do
    CIDR="10.0.${i}.0/24"
    AZ="${REGION}$(echo $i | tr 1-2 a-b)"  # 가용 영역 설정
    SUBNET_JSON=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block "$CIDR" --availability-zone "$AZ")
    SUBNET_ID=$(echo "$SUBNET_JSON" | jq -r '.Subnet.SubnetId')
    echo "$SUBNET_JSON" | jq
    aws ec2 create-tags --resources "$SUBNET_ID" --tags Key=Name,Value="${SUBNET_NAME_PREFIX}-${i}"
    SUBNET_IDS+=("$SUBNET_ID")
    echo "서브넷 생성 완료: $SUBNET_ID, AZ: $AZ"

    # 서브넷에 퍼블릭 IP 자동 할당 활성화
    echo "서브넷 $SUBNET_ID 퍼블릭 IP 자동 할당 활성화 시도..."
    MODIFY_JSON=$(aws ec2 modify-subnet-attribute --subnet-id "$SUBNET_ID" --map-public-ip-on-launch 2>&1)
    if [[ $? -eq 0 ]]; then
      echo "서브넷 $SUBNET_ID 퍼블릭 IP 자동 할당 활성화 완료"
    else
      echo "Error: 서브넷 $SUBNET_ID에 퍼블릭 IP 자동 할당 활성화 실패"
      echo "$MODIFY_JSON"
      exit 1
    fi

    # 서브넷 설정 확인
    SUBNET_CHECK=$(aws ec2 describe-subnets --subnet-ids "$SUBNET_ID")
    PUBLIC_IP_ENABLED=$(echo "$SUBNET_CHECK" | jq -r '.Subnets[0].MapPublicIpOnLaunch')
    if [[ "$PUBLIC_IP_ENABLED" == "true" ]]; then
      echo "서브넷 $SUBNET_ID 설정 확인: 퍼블릭 IP 자동 할당 활성화"
    else
      echo "Error: 서브넷 $SUBNET_ID 설정 확인 실패: 퍼블릭 IP 자동 할당이 활성화되지 않음"
      exit 1
    fi
  done

  # 생성된 서브넷을 기본 라우팅 테이블에 연결
  echo "=== 생성된 서브넷 기본 라우팅 테이블에 연결 ==="
  for SUBNET_ID in "${SUBNET_IDS[@]}"; do
    ASSOC_JSON=$(aws ec2 associate-route-table --route-table-id "$ROUTE_TABLE_ID" --subnet-id "$SUBNET_ID")
    echo "$ASSOC_JSON" | jq
    echo "서브넷 $SUBNET_ID 기본 라우팅 테이블 $ROUTE_TABLE_ID에 연결 완료"
  done

  echo "=== 기본 보안 그룹 수정 ==="
  SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" --query "SecurityGroups[0].GroupId" --output text)

  # 기본 보안 그룹에 태그 추가
  aws ec2 create-tags --resources "$SECURITY_GROUP_ID" --tags Key=Name,Value="${SECURITY_GROUP_TAG_NAME}"
  echo "기본 보안 그룹 태그 추가 완료"

  aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP_ID" \
    --protocol tcp --port 80 --cidr 0.0.0.0/0
  echo "HTTP(80) 인바운드 규칙 추가 완료"

  aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP_ID" \
    --protocol tcp --port 443 --cidr 0.0.0.0/0
  echo "HTTPS(443) 인바운드 규칙 추가 완료"

  echo "=== 네트워크 리소스 생성 완료 ==="
}




# ELB 및 Target Group 배포
deploy_elb() {
  echo "=== ELB 생성 ==="

  # 서브넷 ID 가져오기
  SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME_PREFIX}-*" --query "Subnets[*].SubnetId" --output text)
  if [[ -z "$SUBNET_IDS" ]]; then
    echo "Error: 서브넷 ID를 가져올 수 없습니다. 먼저 네트워크 리소스를 배포하세요."
    exit 1
  fi

  # VPC ID 가져오기
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text)
  if [[ -z "$VPC_ID" ]]; then
    echo "Error: VPC ID를 가져올 수 없습니다. 먼저 네트워크 리소스를 배포하세요."
    exit 1
  fi

  # 서브넷 검증 (동일 VPC에 속하는 서브넷만 사용)
  VALID_SUBNETS=()
  for SUBNET_ID in $SUBNET_IDS; do
    SUBNET_VPC_ID=$(aws ec2 describe-subnets --subnet-ids $SUBNET_ID --query "Subnets[0].VpcId" --output text)
    if [[ "$SUBNET_VPC_ID" == "$VPC_ID" ]]; then
      VALID_SUBNETS+=($SUBNET_ID)
    fi
  done

  # 최소 2개의 유효 서브넷 확인
  if [[ ${#VALID_SUBNETS[@]} -lt 2 ]]; then
    echo "Error: ELB를 생성하려면 동일 VPC(${VPC_ID})에 최소 2개의 서브넷이 필요합니다."
    exit 1
  fi

  # ELB 생성
  ELB_ARN=$(aws elbv2 create-load-balancer --name "${ELB_NAME}" \
    --subnets ${VALID_SUBNETS[0]} ${VALID_SUBNETS[1]} \
    --security-groups $SECURITY_GROUP_ID \
    --scheme internet-facing \
    --type application \
    --query "LoadBalancers[0].LoadBalancerArn" --output text)
  if [[ -z "$ELB_ARN" ]]; then
    echo "Error: ELB 생성에 실패했습니다."
    exit 1
  fi
  echo "ELB 생성 완료: $ELB_ARN"

  echo "=== Target Group 생성 ==="
  TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --no-paginate \
    --name "${TARGET_GROUP_NAME}" \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --target-type ip \
    --query "TargetGroups[0].TargetGroupArn" --output text)
  if [[ -z "$TARGET_GROUP_ARN" ]]; then
    echo "Error: Target Group 생성에 실패했습니다."
    exit 1
  fi
  echo "Target Group 생성 완료: $TARGET_GROUP_ARN"

  echo "=== Listener 생성 ==="
  LISTENER_ARN=$(aws elbv2 create-listener \
    --no-paginate \
    --load-balancer-arn $ELB_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN \
    --query "Listeners[0].ListenerArn" --output text)
  if [[ -z "$LISTENER_ARN" ]]; then
    echo "Error: Listener 생성에 실패했습니다."
    exit 1
  fi
  echo "Listener 생성 완료: $LISTENER_ARN"
}

# ECS 및 Fargate 서비스 배포
deploy_ecs() {
  ecr_push

  echo "=== ECS 클러스터 생성 ==="
  CLUSTER_ARN=$(aws ecs create-cluster --cluster-name "${CLUSTER_NAME}" --query "cluster.clusterArn" --output text --no-paginate)
  echo "ECS 클러스터 생성 완료: $CLUSTER_ARN"

  # 기존 서비스 상태 확인
  EXISTING_SERVICE_STATUS=$(aws ecs describe-services --cluster "${CLUSTER_NAME}" --services "${SERVICE_NAME}" --query "services[0].status" --output text 2>/dev/null)
  echo "기존 서비스 상태: $EXISTING_SERVICE_STATUS"

  # CloudWatch Logs 로그 그룹 생성
  LOG_GROUP_NAME="/ecs/${TASK_DEFINITION}"
  echo "=== CloudWatch Logs 로그 그룹 생성 ==="
  aws logs create-log-group --log-group-name "${LOG_GROUP_NAME}" --region "${REGION}" 2>/dev/null || echo "로그 그룹(${LOG_GROUP_NAME})이 이미 존재합니다."
  echo "CloudWatch Logs 로그 그룹 확인 완료: ${LOG_GROUP_NAME}"

  # Task Definition 업데이트
  update_task_definition

  echo "=== Task Definition 등록 ==="
  aws ecs register-task-definition --cli-input-json file:///tmp/task-definition.json --no-paginate --no-cli-pager
  echo "Task Definition 등록 완료"

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
    echo "Error: Fargate 서비스를 생성하려면 동일한 VPC(${VPC_ID}) 내의 최소 2개의 서브넷이 필요합니다."
    exit 1
  fi
  SUBNET_IDS_JOINED=$(IFS=,; echo "${VALID_SUBNET_IDS[*]}")

  # 보안 그룹 확인
  SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=${SECURITY_GROUP_TAG_NAME}" --query "SecurityGroups[0].GroupId" --output text --no-paginate)
  if [[ -z "$SG_ID" || "$SG_ID" == "None" ]]; then
    echo "Error: 보안 그룹(${SECURITY_GROUP_TAG_NAME}) ID를 가져올 수 없습니다."
    exit 1
  fi

  # ELB 및 Target Group 검증
  TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names "${TARGET_GROUP_NAME}" --query "TargetGroups[0].TargetGroupArn" --output text --no-paginate 2>/dev/null)
  if [[ -z "$TARGET_GROUP_ARN" ]]; then
    echo "Error: Target Group(${TARGET_GROUP_NAME})를 찾을 수 없습니다. 먼저 ELB를 배포하세요."
    exit 1
  fi

  ELB_ARN=$(aws elbv2 describe-load-balancers --names "${ELB_NAME}" --query "LoadBalancers[0].LoadBalancerArn" --output text --no-paginate 2>/dev/null)
  if [[ -z "$ELB_ARN" ]]; then
    echo "Error: Load Balancer(${ELB_NAME})를 찾을 수 없습니다. 먼저 ELB를 배포하세요."
    exit 1
  fi

  echo "=== Fargate 서비스 생성 ==="
  
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
  echo "Fargate 서비스 생성 완료"
}

# API Gateway 배포
deploy_apigateway() {
  echo "=== API Gateway 생성 ==="

  # ELB DNS 가져오기
  ELB_DNS=$(aws elbv2 describe-load-balancers --names "${ELB_NAME}" --query "LoadBalancers[0].DNSName" --output text)
  if [[ -z "$ELB_DNS" ]]; then
    echo "Error: ELB(${ELB_NAME})의 DNS 이름을 가져올 수 없습니다. ELB를 먼저 배포하세요."
    exit 1
  fi
  echo "ELB DNS 확인 완료: $ELB_DNS"

  # 기존 API Gateway 확인 및 삭제
  API_ID=$(aws apigatewayv2 get-apis --query "Items[?Name=='${API_NAME}'].ApiId" --output text)
  if [[ -n "$API_ID" ]]; then
    echo "API Gateway(${API_NAME})가 이미 존재합니다: $API_ID"
    echo "기존 API Gateway를 삭제합니다."
    aws apigatewayv2 delete-api --api-id "$API_ID"
    if [[ $? -ne 0 ]]; then
      echo "Error: 기존 API Gateway 삭제에 실패했습니다."
      exit 1
    fi
    echo "기존 API Gateway 삭제 완료"
  fi

  # 새 API Gateway 생성
  API_ID=$(aws apigatewayv2 create-api \
    --name "${API_NAME}" \
    --protocol-type HTTP \
    --query "ApiId" --output text)
  if [[ -z "$API_ID" ]]; then
    echo "Error: API Gateway 생성에 실패했습니다."
    exit 1
  fi
  echo "API Gateway 생성 완료: $API_ID"

  # /api 경로에 대한 통합 생성
  echo "=== /api 경로 통합 생성 ==="
  API_INTEGRATION_ID=$(aws apigatewayv2 create-integration \
    --api-id "$API_ID" \
    --integration-method ANY \
    --integration-type HTTP_PROXY \
    --integration-uri "http://${ELB_DNS}" \
    --payload-format-version "1.0" \
    --query "IntegrationId" --output text)
  if [[ -z "$API_INTEGRATION_ID" ]]; then
    echo "Error: /api 경로 통합 생성에 실패했습니다."
    exit 1
  fi
  echo "/api 경로 통합 생성 완료: $API_INTEGRATION_ID"

  # /api 경로 라우트 생성
  echo "=== /api 경로 라우트 생성 ==="
  aws apigatewayv2 create-route \
    --api-id "$API_ID" \
    --route-key "ANY /" \
    --target "integrations/$API_INTEGRATION_ID"
  if [[ $? -ne 0 ]]; then
    echo "Error: /api 경로 라우트 생성에 실패했습니다."
    exit 1
  fi
  echo "/api 경로 라우트 생성 완료"

  # default 스테이지 생성
  echo "=== default 스테이지 생성 ==="
  aws apigatewayv2 create-stage \
    --api-id "$API_ID" \
    --stage-name "api" \
    --auto-deploy
  if [[ $? -ne 0 ]]; then
    echo "Error: default 스테이지 생성에 실패했습니다."
    exit 1
  fi
  echo "default 스테이지 생성 완료"

  aws apigatewayv2 get-stages --api-id $API_ID

  # API Gateway URL 출력
  API_URL="https://${API_ID}.execute-api.${REGION}.amazonaws.com/api/"
  echo "API Gateway URL: $API_URL"
}

undeploy_apigateway() {
  echo "=== API Gateway 삭제 ==="
  API_ID=$(aws apigatewayv2 get-apis --query "Items[?Name=='${API_NAME}'].ApiId" --output text 2>/dev/null || echo "")
  if [[ ! -z "$API_ID" ]]; then
    aws apigatewayv2 delete-api --api-id $API_ID
    echo "API Gateway 삭제 완료"
  else
    echo "API Gateway가 존재하지 않습니다."
  fi
}

undeploy_elb() {
  echo "=== ELB 리소스 삭제 ==="

  # ELB ARN 가져오기
  ELB_ARN=$(aws elbv2 describe-load-balancers --names $ELB_NAME --query "LoadBalancers[0].LoadBalancerArn" --output text 2>/dev/null || echo "")
  if [[ -z "$ELB_ARN" || "$ELB_ARN" == "None" ]]; then
    echo "ELB(${ELB_NAME})가 존재하지 않습니다."
  else
    # Listener 삭제
    echo "=== Listener 삭제 ==="
    LISTENER_ARNS=$(aws elbv2 describe-listeners --load-balancer-arn $ELB_ARN --query "Listeners[*].ListenerArn" --output text)
    if [[ -n "$LISTENER_ARNS" ]]; then
      for LISTENER_ARN in $LISTENER_ARNS; do
        echo "Listener 삭제 중: $LISTENER_ARN"
        aws elbv2 delete-listener --listener-arn $LISTENER_ARN
        if [[ $? -ne 0 ]]; then
          echo "Error: Listener 삭제에 실패했습니다: $LISTENER_ARN"
          exit 1
        fi
        echo "Listener 삭제 완료: $LISTENER_ARN"
      done
    else
      echo "Listener가 없습니다."
    fi

    # ELB 삭제
    echo "=== ELB 삭제 ==="
    aws elbv2 delete-load-balancer --load-balancer-arn $ELB_ARN
    if [[ $? -ne 0 ]]; then
      echo "Error: ELB 삭제에 실패했습니다."
      exit 1
    fi
    echo "ELB 삭제 완료: $ELB_NAME"
  fi

  # Target Group 삭제
  echo "=== Target Group 삭제 ==="
  TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names $TARGET_GROUP_NAME --query "TargetGroups[0].TargetGroupArn" --output text 2>/dev/null || echo "")
  if [[ -n "$TARGET_GROUP_ARN" ]]; then
    aws elbv2 delete-target-group --target-group-arn $TARGET_GROUP_ARN
    if [[ $? -ne 0 ]]; then
      echo "Error: Target Group 삭제에 실패했습니다."
      exit 1
    fi
    echo "Target Group 삭제 완료: $TARGET_GROUP_NAME"
  else
    echo "Target Group(${TARGET_GROUP_NAME})가 존재하지 않습니다."
  fi
}


undeploy_ecs() {
  echo "=== Fargate 서비스 삭제 ==="
  aws ecs delete-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --force --no-paginate --no-cli-pager || {
    echo "서비스 삭제 중 오류 발생 또는 서비스가 존재하지 않습니다."
  }
  echo "Fargate 서비스 삭제 완료"

  echo "=== 실행 중인 태스크 중지 ==="
  TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER_NAME --query "taskArns[0]" --output text --no-paginate --no-cli-pager)
  if [[ "$TASK_ARN" != "None" && -n "$TASK_ARN" ]]; then
    aws ecs stop-task --cluster $CLUSTER_NAME --task $TASK_ARN --no-paginate --no-cli-pager
    echo "실행 중인 태스크 중지 완료: $TASK_ARN"
  else
    echo "실행 중인 태스크가 없습니다."
  fi

  echo "=== ECS 클러스터 삭제 ==="
  aws ecs delete-cluster --cluster $CLUSTER_NAME --no-paginate --no-cli-pager || {
    echo "클러스터 삭제 중 오류 발생 또는 클러스터가 존재하지 않습니다."
  }
  echo "ECS 클러스터 삭제 완료"

  echo "=== CloudWatch Logs 로그 그룹 삭제 ==="
  LOG_GROUP_NAME="/ecs/${TASK_DEFINITION}"
  aws logs delete-log-group --log-group-name "${LOG_GROUP_NAME}" --no-paginate --no-cli-pager || {
    echo "로그 그룹(${LOG_GROUP_NAME}) 삭제 중 오류 발생 또는 로그 그룹이 존재하지 않습니다."
  }
  echo "CloudWatch Logs 로그 그룹 삭제 완료"
}

undeploy_network() {
  echo "=== 네트워크 리소스 삭제 ==="

  # VPC ID 확인
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text 2>/dev/null)
  if [[ -z "$VPC_ID" || "$VPC_ID" == "None" ]]; then
    echo "Error: VPC(${VPC_NAME})가 존재하지 않습니다."
    return
  fi
  echo "VPC 확인 완료: $VPC_ID"

  # 네트워크 인터페이스 삭제
  echo "=== 네트워크 인터페이스 삭제 ==="
  NETWORK_INTERFACES=$(aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=$VPC_ID" --query "NetworkInterfaces[*].NetworkInterfaceId" --output text)
  for NI in $NETWORK_INTERFACES; do
    aws ec2 delete-network-interface --network-interface-id "$NI" 2>/dev/null || echo "네트워크 인터페이스 삭제 실패: $NI"
  done

  # NAT 게이트웨이 삭제
  echo "=== NAT 게이트웨이 삭제 ==="
  NAT_GATEWAYS=$(aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" --query "NatGateways[*].NatGatewayId" --output text)
  for NGW in $NAT_GATEWAYS; do
    aws ec2 delete-nat-gateway --nat-gateway-id "$NGW"
    echo "NAT 게이트웨이 삭제 완료: $NGW"
  done

  # 퍼블릭 IP 해제
  echo "=== 퍼블릭 IP 해제 ==="
  EIP_ALLOCATION_IDS=$(aws ec2 describe-addresses --filters "Name=domain,Values=vpc" "Name=public-ip-association.id,Values=$VPC_ID" --query "Addresses[*].AllocationId" --output text)
  for ALLOC_ID in $EIP_ALLOCATION_IDS; do
    aws ec2 release-address --allocation-id "$ALLOC_ID"
    echo "퍼블릭 IP 해제 완료: $ALLOC_ID"
  done

  # 인터넷 게이트웨이 삭제
  echo "=== 인터넷 게이트웨이 삭제 ==="
  IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)
  if [[ -n "$IGW_ID" ]]; then
    aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID" 2>/dev/null || echo "인터넷 게이트웨이 분리 실패: $IGW_ID"
    aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID" 2>/dev/null || echo "인터넷 게이트웨이 삭제 실패: $IGW_ID"
  fi

  # 라우트 테이블 삭제
  echo "=== 라우트 테이블 삭제 ==="
  ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[*].RouteTableId" --output text)
  for RT_ID in $ROUTE_TABLE_IDS; do
    ASSOCIATIONS=$(aws ec2 describe-route-tables --route-table-ids "$RT_ID" --query "RouteTables[0].Associations[*].RouteTableAssociationId" --output text)
    for ASSOC_ID in $ASSOCIATIONS; do
      aws ec2 disassociate-route-table --association-id "$ASSOC_ID"
    done
    aws ec2 delete-route-table --route-table-id "$RT_ID" || echo "라우트 테이블 삭제 실패: $RT_ID"
  done

  # 서브넷 삭제
  echo "=== 서브넷 삭제 ==="
  SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[*].SubnetId" --output text)
  for SUBNET_ID in $SUBNET_IDS; do
    aws ec2 delete-subnet --subnet-id "$SUBNET_ID" || echo "서브넷 삭제 실패: $SUBNET_ID"
  done

  # 보안 그룹 삭제
  echo "=== 보안 그룹 삭제 ==="
  SECURITY_GROUP_IDS=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query "SecurityGroups[*].GroupId" --output text)
  DEFAULT_SG_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" --query "SecurityGroups[0].GroupId" --output text)
  for SG_ID in $SECURITY_GROUP_IDS; do
    if [[ "$SG_ID" == "$DEFAULT_SG_ID" ]]; then
      echo "기본 보안 그룹($SG_ID)은 삭제하지 않습니다."
      continue
    fi
    aws ec2 delete-security-group --group-id "$SG_ID" || echo "보안 그룹 삭제 실패: $SG_ID"
  done

  # VPC 삭제
  echo "=== VPC 삭제 ==="
  aws ec2 delete-vpc --vpc-id "$VPC_ID" || echo "VPC 삭제 실패: $VPC_ID"
}

check_network() {
  echo "=== 네트워크 리소스 조회 ==="

  # VPC 조회
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text)
  if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
    echo "VPC(${VPC_NAME})가 존재하지 않습니다."
    return
  fi
  echo "VPC ID: $VPC_ID"

  # 서브넷 조회
  SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME_PREFIX}-*" --query "Subnets[*].{ID:SubnetId,AZ:AvailabilityZone}" --output json)
  if [[ -z "$SUBNET_IDS" ]]; then
    echo "서브넷(${SUBNET_NAME_PREFIX})이 존재하지 않습니다."
  else
    echo "서브넷 정보:"
    echo "$SUBNET_IDS"
  fi

  # 라우팅 테이블 조회
  echo "라우팅 테이블 정보:"
  for SUBNET_ID in $(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME_PREFIX}-*" --query "Subnets[*].SubnetId" --output text); do
    ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=${SUBNET_ID}" --query "RouteTables[0].RouteTableId" --output text)
    echo "  서브넷 ${SUBNET_ID} 연결 라우팅 테이블: $ROUTE_TABLE_ID"
    ROUTES=$(aws ec2 describe-route-tables --route-table-ids $ROUTE_TABLE_ID --query "RouteTables[0].Routes" --output json)
    echo "  라우팅 테이블 ${ROUTE_TABLE_ID} 경로 정보: $ROUTES"
  done

  # 보안 그룹 조회
  SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=${SECURITY_GROUP_TAG_NAME}" --query "SecurityGroups[0].GroupId" --output text)
  if [[ "$SECURITY_GROUP_ID" == "None" || -z "$SECURITY_GROUP_ID" ]]; then
    echo "보안 그룹(${SECURITY_GROUP_TAG_NAME})이 존재하지 않습니다."
  else
    echo "보안 그룹 ID: $SECURITY_GROUP_ID"
    echo "보안 그룹 아웃바운드 규칙:"
    aws ec2 describe-security-groups --group-ids $SECURITY_GROUP_ID --query "SecurityGroups[0].IpPermissionsEgress" --output json
  fi

  # 인터넷 게이트웨이 조회
  IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=${VPC_ID}" --query "InternetGateways[0].InternetGatewayId" --output text)
  if [[ "$IGW_ID" == "None" || -z "$IGW_ID" ]]; then
    echo "인터넷 게이트웨이가 VPC(${VPC_ID})에 연결되어 있지 않습니다."
  else
    echo "인터넷 게이트웨이 ID: $IGW_ID"
  fi
}

check_elb_details() {
  echo "=== ELB 상세 점검 ==="

  # ELB ARN 확인
  ELB_ARN=$(aws elbv2 describe-load-balancers --names "${ELB_NAME}" --query "LoadBalancers[0].LoadBalancerArn" --output text 2>/dev/null)
  if [[ -z "$ELB_ARN" || "$ELB_ARN" == "None" ]]; then
    echo "Error: ELB(${ELB_NAME})가 존재하지 않습니다."
    exit 1
  fi
  echo "ELB ARN: $ELB_ARN"

  # ELB 보안 그룹 확인
  echo "1. ELB 보안 그룹 확인"
  SECURITY_GROUPS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].SecurityGroups" --output text)
  if [[ -n "$SECURITY_GROUPS" ]]; then
    echo "ELB 보안 그룹: $SECURITY_GROUPS"
    for SG in $SECURITY_GROUPS; do
      echo "보안 그룹($SG)의 인바운드 규칙:"
      SG_RULES=$(aws ec2 describe-security-groups --group-ids "$SG" --query "SecurityGroups[0].IpPermissions" --output json)
      echo "$SG_RULES" | jq .

      HTTP_ALLOWED=$(echo "$SG_RULES" | jq -e '.[] | select(.FromPort==80 and .ToPort==80 and .IpProtocol=="tcp")')
      HTTPS_ALLOWED=$(echo "$SG_RULES" | jq -e '.[] | select(.FromPort==443 and .ToPort==443 and .IpProtocol=="tcp")')

      if [[ -z "$HTTP_ALLOWED" ]]; then
        echo "Error: HTTP(80) 인바운드 규칙이 없습니다."
      else
        echo "HTTP(80) 인바운드 규칙이 설정되어 있습니다."
      fi

      if [[ -z "$HTTPS_ALLOWED" ]]; then
        echo "Error: HTTPS(443) 인바운드 규칙이 없습니다."
      else
        echo "HTTPS(443) 인바운드 규칙이 설정되어 있습니다."
      fi
    done
  else
    echo "Error: ELB에 할당된 보안 그룹이 없습니다."
  fi

  # 네트워크 ACL 확인
  echo "2. 네트워크 ACL 확인"
  SUBNET_IDS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].AvailabilityZones[*].SubnetId" --output text)
  if [[ -n "$SUBNET_IDS" ]]; then
    echo "ELB 서브넷: $SUBNET_IDS"
    for SUBNET_ID in $SUBNET_IDS; do
      NETWORK_ACL=$(aws ec2 describe-network-acls --filters "Name=association.subnet-id,Values=${SUBNET_ID}" --query "NetworkAcls[0]" --output json)
      echo "서브넷($SUBNET_ID)의 네트워크 ACL:"
      echo "$NETWORK_ACL" | jq .
    done
  else
    echo "Error: ELB와 연결된 서브넷을 가져올 수 없습니다."
  fi

  # 퍼블릭 서브넷 확인
  echo "3. 퍼블릭 서브넷 확인"
  for SUBNET_ID in $SUBNET_IDS; do
    # 서브넷에 연결된 라우팅 테이블 ID 가져오기
    ROUTE_TABLE_ID=$(aws ec2 describe-route-tables \
      --filters "Name=association.subnet-id,Values=$SUBNET_ID" \
      --query "RouteTables[0].RouteTableId" \
      --output text 2>/dev/null)

    if [[ -z "$ROUTE_TABLE_ID" || "$ROUTE_TABLE_ID" == "None" ]]; then
      echo "Error: 서브넷($SUBNET_ID)은 라우팅 테이블이 연결되지 않았거나 존재하지 않습니다."
      continue
    fi

    # IGW 경로 확인
    IGW_ROUTE=$(aws ec2 describe-route-tables \
      --route-table-ids "$ROUTE_TABLE_ID" \
      --query "RouteTables[0].Routes[?DestinationCidrBlock=='0.0.0.0/0'].GatewayId" \
      --output text 2>/dev/null)

    if [[ "$IGW_ROUTE" == igw-* ]]; then
      echo "서브넷($SUBNET_ID)은 퍼블릭 서브넷입니다. (IGW: $IGW_ROUTE)"
    else
      echo "Error: 서브넷($SUBNET_ID)은 퍼블릭 서브넷이 아닙니다."
    fi
  done

  # 인터넷 게이트웨이 연결 확인
  echo "4. 인터넷 게이트웨이 연결 확인"
  VPC_ID=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].VpcId" --output text)
  IGW_ID=$(aws ec2 describe-internet-gateways \
    --filters "Name=attachment.vpc-id,Values=$VPC_ID" \
    --query "InternetGateways[0].InternetGatewayId" \
    --output text)

  if [[ -n "$IGW_ID" ]]; then
    echo "인터넷 게이트웨이($IGW_ID)가 VPC($VPC_ID)에 연결되어 있습니다."
  else
    echo "Error: 인터넷 게이트웨이가 VPC($VPC_ID)에 연결되어 있지 않습니다."
  fi

  echo "=== ELB 상세 점검 완료 ==="

  # ELB DNS 이름 확인
  echo "5. ELB DNS 이름 확인"
  ELB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].DNSName" --output text)
  if [[ -n "$ELB_DNS" ]]; then
    echo "ELB DNS 이름: $ELB_DNS"
  else
    echo "Error: ELB DNS 이름을 가져올 수 없습니다."
  fi

  # Target Group과 Listener 설정 확인
  echo "6. Target Group 및 Listener 설정 확인"
  LISTENERS=$(aws elbv2 describe-listeners --load-balancer-arn "$ELB_ARN" --query "Listeners[*]" --output json)
  if [[ -n "$LISTENERS" ]]; then
    echo "ELB Listener 설정:"
    echo "$LISTENERS"
  else
    echo "Error: Listener 정보를 가져올 수 없습니다."
  fi

  TARGET_GROUPS=$(aws elbv2 describe-target-groups --load-balancer-arn "$ELB_ARN" --query "TargetGroups[*]" --output json)
  if [[ -n "$TARGET_GROUPS" ]]; then
    echo "ELB Target Group 설정:"
    echo "$TARGET_GROUPS"
  else
    echo "Error: Target Group 정보를 가져올 수 없습니다."
  fi

  # curl로 연결 확인
  echo "7. ELB 연결 테스트"
  if [[ -n "$ELB_DNS" ]]; then
    RESPONSE_CODE=$(curl -m 5 -s -o /dev/null -w "%{http_code}" "http://$ELB_DNS/")
    echo "ELB 연결 테스트 응답 코드: $RESPONSE_CODE"
  else
    echo "Error: ELB DNS를 통해 연결 테스트를 실행할 수 없습니다."
  fi

  echo "=== ELB 상세 점검 완료 ==="
}


# 전체 리소스 배포
deploy_all() {
  deploy_network
  deploy_elb
  deploy_ecs
  deploy_apigateway
}

# 전체 리소스 삭제
undeploy_all() {
  undeploy_apigateway
  undeploy_ecs
  undeploy_elb
  undeploy_network
}

# 도움말 출력
show_help() {
  cat <<EOF
Usage: $0 [command]

Commands:
  deploy-network       Deploy network resources including VPC, Subnets, IGW, Route Table, and Security Groups.
  deploy-elb           Deploy an Application Load Balancer (ELB) and associated Target Group.
  deploy-ecs           Deploy ECS Cluster, register Task Definition, and launch a Fargate Service.
  deploy-apigateway    Deploy an API Gateway with integration to the ELB.
  deploy-all           Deploy all resources (network, ELB, ECS, API Gateway) in sequence.

  undeploy-network     Remove network resources including VPC, Subnets, IGW, Route Table, and Security Groups.
  undeploy-elb         Remove the ELB, Target Group, and associated Listeners.
  undeploy-ecs         Remove ECS Cluster, Task Definitions, and Fargate Service.
  undeploy-apigateway  Remove the API Gateway and its configurations.
  undeploy-all         Remove all resources (API Gateway, ECS, ELB, network) in sequence.

  update-ecs           Update ECS Service with a new Docker image and Task Definition.

  check-network        Display details of the deployed network resources (VPC, Subnets, IGW, Security Groups).
  check-elb            Validate ELB configuration including security groups, ACLs, public DNS, and connectivity.

  help                 Show this help message and exit.

Description:
  Use this script to manage the deployment and cleanup of AWS resources for a scalable web application.
  Ensure the AWS CLI is configured with appropriate credentials and permissions before running these commands.
EOF
}


# 명령 처리
check_dependencies

case "$1" in
  deploy-network) deploy_network ;;
  deploy-elb) deploy_elb ;;
  deploy-ecs) deploy_ecs ;;
  deploy-apigateway) deploy_apigateway ;;
  deploy-all) deploy_all ;;
  undeploy-network) undeploy_network ;;
  undeploy-elb) undeploy_elb ;;
  undeploy-ecs) undeploy_ecs ;;
  undeploy-apigateway) undeploy_apigateway ;;
  undeploy-all) undeploy_all ;;
  update-ecs) update_ecs ;;
  check-network) check_network;;
  check-elb) check_elb_details ;;
  help|*) show_help ;;
esac
