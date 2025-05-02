#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helper_functions.sh"

# API Gateway 배포
deploy() {
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

undeploy() {
  echo "=== API Gateway 삭제 ==="
  API_ID=$(aws apigatewayv2 get-apis --query "Items[?Name=='${API_NAME}'].ApiId" --output text 2>/dev/null || echo "")
  if [[ ! -z "$API_ID" ]]; then
    aws apigatewayv2 delete-api --api-id $API_ID
    echo "API Gateway 삭제 완료"
  else
    echo "API Gateway가 존재하지 않습니다."
  fi
}

# 도움말 출력
# 도움말 출력
show_help() {
    cat <<EOF
Usage: $0 {deploy|undeploy|help}

Commands:
  deploy      Deploy an API Gateway integrated with the Application Load Balancer (ELB).
  undeploy    Remove the API Gateway and its integrations.
  help        Show this help message.

Configuration:
  API Gateway Name:     ${API_NAME}
  ELB Name:             ${ELB_NAME}
  ELB Integration URI:  http://${ELB_NAME}
  Region:               ${REGION}
EOF
}

# 스크립트를 단독 실행할 때만 check_dependencies와 exec 실행
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  check_dependencies
  exec "$@"
fi