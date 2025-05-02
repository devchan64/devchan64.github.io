#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helper_functions.sh"

# 네트워크 리소스 배포
deploy() {
  log "=== VPC 생성 ==="
  VPC_JSON=$(aws ec2 create-vpc --cidr-block "10.0.0.0/16")
  VPC_ID=$(log "$VPC_JSON" | jq -r '.Vpc.VpcId')
  log "$VPC_JSON" | jq
  aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value="${VPC_NAME}"
  log "VPC 생성 완료: $VPC_ID"

  log "=== 인터넷 게이트웨이 생성 및 연결 ==="
  IGW_JSON=$(aws ec2 create-internet-gateway)
  IGW_ID=$(log "$IGW_JSON" | jq -r '.InternetGateway.InternetGatewayId')
  log "$IGW_JSON" | jq
  aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id "$IGW_ID"
  log "인터넷 게이트웨이 생성 및 연결 완료: $IGW_ID"

  # 인터넷 게이트웨이에 태그 추가
  aws ec2 create-tags --resources "$IGW_ID" --tags Key=Name,Value="${IGW_NAME}"
  log "인터넷 게이트웨이 태그 추가 완료: $IGW_ID"

  log "=== 기본 라우팅 테이블 수정 ==="
  ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.main,Values=true" --query "RouteTables[0].RouteTableId" --output text)
  aws ec2 create-route --route-table-id "$ROUTE_TABLE_ID" --destination-cidr-block "0.0.0.0/0" --gateway-id "$IGW_ID"
  log "기본 라우팅 테이블($ROUTE_TABLE_ID)에 IGW 경로 추가 완료"

  # 기본 라우팅 테이블에 태그 추가
  aws ec2 create-tags --resources "$ROUTE_TABLE_ID" --tags Key=Name,Value="${ROUTE_TABLE_TAG_NAME}"
  log "기본 라우팅 테이블 태그 추가 완료"

  log "=== 퍼블릭 서브넷 생성 ==="
  SUBNET_IDS=()
  for i in 1 2; do
    CIDR="10.0.${i}.0/24"
    AZ="${REGION}$(log $i | tr 1-2 a-b)" # 가용 영역 설정
    SUBNET_JSON=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block "$CIDR" --availability-zone "$AZ")
    SUBNET_ID=$(log "$SUBNET_JSON" | jq -r '.Subnet.SubnetId')
    log "$SUBNET_JSON" | jq
    aws ec2 create-tags --resources "$SUBNET_ID" --tags Key=Name,Value="${SUBNET_NAME_PREFIX}-${i}"
    SUBNET_IDS+=("$SUBNET_ID")
    log "서브넷 생성 완료: $SUBNET_ID, AZ: $AZ"

    # 서브넷에 퍼블릭 IP 자동 할당 활성화
    log "서브넷 $SUBNET_ID 퍼블릭 IP 자동 할당 활성화 시도..."
    MODIFY_JSON=$(aws ec2 modify-subnet-attribute --subnet-id "$SUBNET_ID" --map-public-ip-on-launch 2>&1)
    if [[ $? -eq 0 ]]; then
      log "서브넷 $SUBNET_ID 퍼블릭 IP 자동 할당 활성화 완료"
    else
      log "Error: 서브넷 $SUBNET_ID에 퍼블릭 IP 자동 할당 활성화 실패"
      log "$MODIFY_JSON"
      exit 1
    fi

    # 서브넷 설정 확인
    SUBNET_CHECK=$(aws ec2 describe-subnets --subnet-ids "$SUBNET_ID")
    PUBLIC_IP_ENABLED=$(log "$SUBNET_CHECK" | jq -r '.Subnets[0].MapPublicIpOnLaunch')
    if [[ "$PUBLIC_IP_ENABLED" == "true" ]]; then
      log "서브넷 $SUBNET_ID 설정 확인: 퍼블릭 IP 자동 할당 활성화"
    else
      log "Error: 서브넷 $SUBNET_ID 설정 확인 실패: 퍼블릭 IP 자동 할당이 활성화되지 않음"
      exit 1
    fi
  done

  # 생성된 서브넷을 기본 라우팅 테이블에 연결
  log "=== 생성된 서브넷 기본 라우팅 테이블에 연결 ==="
  for SUBNET_ID in "${SUBNET_IDS[@]}"; do
    ASSOC_JSON=$(aws ec2 associate-route-table --route-table-id "$ROUTE_TABLE_ID" --subnet-id "$SUBNET_ID")
    log "$ASSOC_JSON" | jq
    log "서브넷 $SUBNET_ID 기본 라우팅 테이블 $ROUTE_TABLE_ID에 연결 완료"
  done

  log "=== 기본 보안 그룹 수정 ==="
  SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" --query "SecurityGroups[0].GroupId" --output text)

  # 기본 보안 그룹에 태그 추가
  aws ec2 create-tags --resources "$SECURITY_GROUP_ID" --tags Key=Name,Value="${SECURITY_GROUP_TAG_NAME}"
  log "기본 보안 그룹 태그 추가 완료"

  aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP_ID" \
    --protocol tcp --port 80 --cidr 0.0.0.0/0
  log "HTTP(80) 인바운드 규칙 추가 완료"

  aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP_ID" \
    --protocol tcp --port 443 --cidr 0.0.0.0/0
  log "HTTPS(443) 인바운드 규칙 추가 완료"

  log "=== 네트워크 리소스 생성 완료 ==="
}

undeploy() {
  log "=== 네트워크 리소스 삭제 ==="

  # VPC ID 확인
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text 2>/dev/null)
  if [[ -z "$VPC_ID" || "$VPC_ID" == "None" ]]; then
    log "Error: VPC(${VPC_NAME})가 존재하지 않습니다."
    return
  fi
  log "VPC 확인 완료: $VPC_ID"

  # 네트워크 인터페이스 삭제
  log "=== 네트워크 인터페이스 삭제 ==="
  NETWORK_INTERFACES=$(aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=$VPC_ID" --query "NetworkInterfaces[*].NetworkInterfaceId" --output text)
  for NI in $NETWORK_INTERFACES; do
    aws ec2 delete-network-interface --network-interface-id "$NI" 2>/dev/null || log "네트워크 인터페이스 삭제 실패: $NI"
  done

  # NAT 게이트웨이 삭제
  log "=== NAT 게이트웨이 삭제 ==="
  NAT_GATEWAYS=$(aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" --query "NatGateways[*].NatGatewayId" --output text)
  for NGW in $NAT_GATEWAYS; do
    aws ec2 delete-nat-gateway --nat-gateway-id "$NGW"
    log "NAT 게이트웨이 삭제 완료: $NGW"
  done

  # 퍼블릭 IP 해제
  log "=== 퍼블릭 IP 해제 ==="
  EIP_ALLOCATION_IDS=$(aws ec2 describe-addresses --filters "Name=domain,Values=vpc" "Name=public-ip-association.id,Values=$VPC_ID" --query "Addresses[*].AllocationId" --output text)
  for ALLOC_ID in $EIP_ALLOCATION_IDS; do
    aws ec2 release-address --allocation-id "$ALLOC_ID"
    log "퍼블릭 IP 해제 완료: $ALLOC_ID"
  done

  # 인터넷 게이트웨이 삭제
  log "=== 인터넷 게이트웨이 삭제 ==="
  IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)
  if [[ -n "$IGW_ID" ]]; then
    aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID" 2>/dev/null || log "인터넷 게이트웨이 분리 실패: $IGW_ID"
    aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID" 2>/dev/null || log "인터넷 게이트웨이 삭제 실패: $IGW_ID"
  fi

  # 라우트 테이블 삭제
  log "=== 라우트 테이블 삭제 ==="
  ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[*].RouteTableId" --output text)
  for RT_ID in $ROUTE_TABLE_IDS; do
    ASSOCIATIONS=$(aws ec2 describe-route-tables --route-table-ids "$RT_ID" --query "RouteTables[0].Associations[*].RouteTableAssociationId" --output text)
    for ASSOC_ID in $ASSOCIATIONS; do
      aws ec2 disassociate-route-table --association-id "$ASSOC_ID"
    done
    aws ec2 delete-route-table --route-table-id "$RT_ID" || log "라우트 테이블 삭제 실패: $RT_ID"
  done

  # 서브넷 삭제
  log "=== 서브넷 삭제 ==="
  SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[*].SubnetId" --output text)
  for SUBNET_ID in $SUBNET_IDS; do
    aws ec2 delete-subnet --subnet-id "$SUBNET_ID" || log "서브넷 삭제 실패: $SUBNET_ID"
  done

  # 보안 그룹 삭제
  log "=== 보안 그룹 삭제 ==="
  SECURITY_GROUP_IDS=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query "SecurityGroups[*].GroupId" --output text)
  DEFAULT_SG_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" --query "SecurityGroups[0].GroupId" --output text)
  for SG_ID in $SECURITY_GROUP_IDS; do
    if [[ "$SG_ID" == "$DEFAULT_SG_ID" ]]; then
      log "기본 보안 그룹($SG_ID)은 삭제하지 않습니다."
      continue
    fi
    aws ec2 delete-security-group --group-id "$SG_ID" || log "보안 그룹 삭제 실패: $SG_ID"
  done

  # VPC 삭제
  log "=== VPC 삭제 ==="
  aws ec2 delete-vpc --vpc-id "$VPC_ID" || log "VPC 삭제 실패: $VPC_ID"
}

show_help() {
    cat <<EOF
Usage: $0 {deploy|undeploy|help}

Commands:
  deploy      Deploy network resources including VPC, Subnets, IGW, and Route Table.
  undeploy    Remove network resources.
  help        Show this help message.
EOF
}

# 스크립트를 단독 실행할 때만 check_dependencies와 exec 실행
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  check_dependencies
  exec "$@"
fi