#!/bin/bash
# config.sh
# cbsim

# ========================
# 1. 공통 설정
# ========================
# 프로젝트의 공통 설정 값을 정의합니다.
PREFIX="test"              # 리소스 이름에 공통적으로 사용될 접두사
REGION="ap-northeast-2"                # AWS 리소스를 생성할 AWS 리전
ACCOUNT_ID=                # AWS 계정 ID
AWS_CLI_OPTS="--no-paginate --no-cli-pager" # AWS CLI 옵션

# ========================
# 2. ECS 및 애플리케이션 설정
# ========================
# ECS 및 애플리케이션 관련 리소스 이름을 정의합니다.
APP_NAME="${PREFIX}-app"               # 애플리케이션 이름
CLUSTER_NAME="${PREFIX}-cluster"       # ECS 클러스터 이름
SERVICE_NAME="${PREFIX}-service"       # ECS 서비스 이름
TASK_DEFINITION="${PREFIX}-task"       # ECS 작업 정의(Task Definition) 이름
STAGE_NAME="prod"                      # API Gateway 단계 이름

# ========================
# 3. 네트워크 리소스 설정
# ========================
# VPC, 서브넷, 보안 그룹 등 네트워크 리소스 관련 이름을 정의합니다.
VPC_NAME="${PREFIX}-vpc"               # VPC 이름
SUBNET_NAME_PREFIX="${PREFIX}-public-subnet" # 퍼블릭 서브넷 이름 접두사
SECURITY_GROUP_TAG_NAME="${PREFIX}-security-group"  # 보안 그룹 태그 이름
ROUTE_TABLE_TAG_NAME="${PREFIX}-route-table"        # 라우팅 테이블 태그 이름
IGW_NAME="${PREFIX}-igw"               # 인터넷 게이트웨이 이름

# ========================
# 4. 로드 밸런서 리소스 설정
# ========================
# Elastic Load Balancer 및 관련 리소스 이름을 정의합니다.
ELB_NAME="${PREFIX}-elb"               # Elastic Load Balancer 이름
TARGET_GROUP_NAME="${PREFIX}-target-group"  # ELB 타겟 그룹 이름

# ========================
# 5. IAM 역할 설정
# ========================
# ECS 작업 및 실행에 필요한 IAM 역할 이름을 정의합니다.
TASK_ROLE_NAME="${PREFIX}-task-role"   # ECS 작업(Task) 역할 이름
EXEC_ROLE_NAME="${PREFIX}-exec-role"   # ECS 실행(Execution) 역할 이름

# ========================
# 6. 컨테이너 및 이미지 설정
# ========================
# Amazon ECR 및 컨테이너 관련 설정을 정의합니다.
REPOSITORY_NAME="${PREFIX}-repo"       # ECR 리포지토리 이름
ECR_REPO_URL="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}" # ECR 리포지토리 URL

# ========================
# 7. JSON 템플릿 파일 경로
# ========================
# ECS 작업 정의 및 IAM 역할 생성을 위한 템플릿 파일 경로를 정의합니다.
SOURCE_FILE="${SCRIPT_DIR}/task-definition-template.json"  # 작업 정의 템플릿 파일
TARGET_FILE="/tmp/task-definition.json"                   # 수정된 작업 정의 파일 저장 경로
ROLE_FILE="${SCRIPT_DIR}/role-template.json"              # IAM 역할 템플릿 파일

# ========================
# 8. DynamoDB 설정
# ========================
# DynamoDB 테이블 등을 정의합니다.
DOC_DYNAMO_TB_NAME="${PREFIX}-doc-table"
REVISION_DYNAMO_TB_NAME="${PREFIX}-doc-revisions-table"
SUBSCRIPTIONS_DYNAMO_TB_NAME="${PREFIX}-doc-subscriptions-table"

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