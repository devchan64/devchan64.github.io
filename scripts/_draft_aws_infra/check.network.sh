#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helper_functions.sh"

check_network() {
    echo "=== 네트워크 리소스 확인 시작 ==="

    # VPC 확인
    echo "[1] VPC 확인"
    VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text $AWS_CLI_OPTS)
    if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
        echo "VPC(${VPC_NAME})가 존재하지 않습니다."
    else
        echo "VPC ID: $VPC_ID"
    fi

    # 서브넷 확인
    echo "[2] 서브넷 확인"
    SUBNETS=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME_PREFIX}-*" --query "Subnets[*].[SubnetId,AvailabilityZone]" --output table $AWS_CLI_OPTS)
    if [[ -z "$SUBNETS" ]]; then
        echo "서브넷(${SUBNET_NAME_PREFIX})이 존재하지 않습니다."
    else
        echo "서브넷 정보:"
        echo "$SUBNETS"
    fi

    # 라우팅 테이블 확인
    echo "[3] 라우팅 테이블 확인"
    ROUTE_TABLES=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[*].[RouteTableId,Associations[0].SubnetId]" --output table $AWS_CLI_OPTS)
    if [[ -z "$ROUTE_TABLES" ]]; then
        echo "라우팅 테이블이 존재하지 않습니다."
    else
        echo "라우팅 테이블 정보:"
        echo "$ROUTE_TABLES"
    fi

    # 보안 그룹 확인
    echo "[4] 보안 그룹 확인"
    SECURITY_GROUP=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=${SECURITY_GROUP_TAG_NAME}" --query "SecurityGroups[0]" --output json $AWS_CLI_OPTS)
    if [[ -z "$SECURITY_GROUP" ]]; then
        echo "보안 그룹(${SECURITY_GROUP_TAG_NAME})이 존재하지 않습니다."
    else
        echo "보안 그룹 정보:"
        echo "$SECURITY_GROUP" | jq
    fi

    # 인터넷 게이트웨이 확인
    echo "[5] 인터넷 게이트웨이 확인"
    IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text $AWS_CLI_OPTS)
    if [[ "$IGW_ID" == "None" || -z "$IGW_ID" ]]; then
        echo "인터넷 게이트웨이가 VPC(${VPC_ID})에 연결되어 있지 않습니다."
    else
        echo "인터넷 게이트웨이 ID: $IGW_ID"
    fi

    echo "=== 네트워크 리소스 확인 완료 ==="
}

show_help() {
    cat <<EOF
Usage: $0 {check|help}

Commands:
  check       Check the deployed network resources (VPC, Subnets, Route Tables, Security Groups, IGW).
  help        Show this help message.

Configuration:
  VPC Name:             ${VPC_NAME}
  Subnet Name Prefix:   ${SUBNET_NAME_PREFIX}
  Security Group Name:  ${SECURITY_GROUP_TAG_NAME}
  Region:               ${REGION}
EOF
}

# 명령 처리
case "$1" in
    check)
        check_network
        ;;
    help)
        show_help
        ;;
    *)
        echo "Usage: $0 {check|help}"
        exit 1
        ;;
esac
