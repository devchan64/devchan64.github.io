#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helper_functions.sh"

check_elb() {
    echo "=== ELB 상세 점검 시작 ==="

    # ELB ARN 확인
    echo "[1] ELB ARN 확인"
    ELB_ARN=$(aws elbv2 describe-load-balancers --names "${ELB_NAME}" --query "LoadBalancers[0].LoadBalancerArn" --output text $AWS_CLI_OPTS)
    if [[ -z "$ELB_ARN" || "$ELB_ARN" == "None" ]]; then
        echo "Error: ELB(${ELB_NAME})가 존재하지 않습니다."
        exit 1
    fi
    echo "ELB ARN: $ELB_ARN"

    # ELB 서브넷 확인
    echo "[2] ELB와 연결된 서브넷"
    SUBNET_IDS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].AvailabilityZones[*].SubnetId" --output text $AWS_CLI_OPTS)
    if [[ -z "$SUBNET_IDS" ]]; then
        echo "Error: ELB와 연결된 서브넷이 없습니다."
    else
        echo "연결된 서브넷 ID: $SUBNET_IDS"
    fi

    # ELB 보안 그룹 확인
    echo "[3] ELB 보안 그룹"
    SECURITY_GROUPS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].SecurityGroups" --output text $AWS_CLI_OPTS)
    if [[ -z "$SECURITY_GROUPS" ]]; then
        echo "Error: ELB에 연결된 보안 그룹이 없습니다."
    else
        echo "연결된 보안 그룹 ID: $SECURITY_GROUPS"
        for SG_ID in $SECURITY_GROUPS; do
            SG_RULES=$(aws ec2 describe-security-groups --group-ids "$SG_ID" --query "SecurityGroups[0].IpPermissions" --output json)
            echo "보안 그룹 $SG_ID 규칙:"
            echo "$SG_RULES" | jq .
        done
    fi

    # Target Group 확인
    echo "[4] Target Group 확인"
    TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names "${TARGET_GROUP_NAME}" --query "TargetGroups[0].TargetGroupArn" --output text $AWS_CLI_OPTS)
    if [[ -z "$TARGET_GROUP_ARN" ]]; then
        echo "Error: Target Group(${TARGET_GROUP_NAME})가 존재하지 않습니다."
    else
        echo "Target Group ARN: $TARGET_GROUP_ARN"

        echo "Target Group 상태:"
        aws elbv2 describe-target-health --target-group-arn "$TARGET_GROUP_ARN" --query "TargetHealthDescriptions[*]" --output json | jq .
    fi

    # Listener 확인
    echo "[5] Listener 확인"
    LISTENERS=$(aws elbv2 describe-listeners --load-balancer-arn "$ELB_ARN" --query "Listeners[*]" --output json $AWS_CLI_OPTS)
    if [[ -z "$LISTENERS" ]]; then
        echo "Error: ELB에 연결된 Listener가 없습니다."
    else
        echo "Listener 정보:"
        echo "$LISTENERS" | jq .
    fi

    # ELB DNS 확인
    echo "[6] ELB DNS 확인"
    ELB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ELB_ARN" --query "LoadBalancers[0].DNSName" --output text $AWS_CLI_OPTS)
    if [[ -z "$ELB_DNS" ]]; then
        echo "Error: ELB의 DNS 이름을 가져올 수 없습니다."
    else
        echo "ELB DNS 이름: $ELB_DNS"
    fi

    # ELB 연결 테스트
    echo "[7] ELB 연결 테스트"
    if [[ -n "$ELB_DNS" ]]; then
        RESPONSE_CODE=$(curl -m 5 -s -o /dev/null -w "%{http_code}" "http://$ELB_DNS/")
        echo "ELB 연결 테스트 응답 코드: $RESPONSE_CODE"
    else
        echo "Error: ELB DNS를 통해 연결 테스트를 실행할 수 없습니다."
    fi

    echo "=== ELB 상세 점검 완료 ==="
}

show_help() {
    cat <<EOF
Usage: $0 {check|help}

Commands:
  check       Validate the configuration and status of the Elastic Load Balancer (ELB).
  help        Show this help message.

Details:
  - Check the ELB ARN, Subnets, Security Groups, Target Groups, and Listeners.
  - Test the ELB DNS connectivity.

Configuration:
  ELB Name:             ${ELB_NAME}
  Target Group Name:    ${TARGET_GROUP_NAME}
  Region:               ${REGION}
EOF
}

# 명령 처리
case "$1" in
    check)
        check_elb
        ;;
    help)
        show_help
        ;;
    *)
        echo "Usage: $0 {check|help}"
        exit 1
        ;;
esac
