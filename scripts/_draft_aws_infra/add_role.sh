#! /bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source $SCRIPT_DIR/config.sh

echo "=== IAM 역할 생성 및 정책 연결 ==="

# ROLE_FILE 템플릿 경로 확인
if [[ ! -f "$ROLE_FILE" ]]; then
echo "Error: ROLE_FILE($ROLE_FILE)이 존재하지 않습니다."
exit 1
fi

# Execution Role 생성 (ECR 전용)
echo "Execution Role 확인 중..."
EXEC_ROLE_EXISTS=$(aws iam get-role --role-name "$EXEC_ROLE_NAME" --query "Role.Arn" --output text 2>/dev/null)

if [[ -z "$EXEC_ROLE_EXISTS" ]]; then
echo "Execution Role이 존재하지 않습니다. 생성 중..."
EXEC_ROLE_ARN=$(aws iam create-role \
    --role-name "$EXEC_ROLE_NAME" \
    --assume-role-policy-document "file://$ROLE_FILE" \
    --query "Role.Arn" --output text)
echo "Execution Role 생성 완료: $EXEC_ROLE_ARN"

# Execution Role에 ECR 및 CloudWatch Logs 권한 연결
aws iam attach-role-policy \
    --role-name "$EXEC_ROLE_NAME" \
    --policy-arn "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
echo "Execution Role에 AmazonECSTaskExecutionRolePolicy 연결 완료."
else
EXEC_ROLE_ARN="$EXEC_ROLE_EXISTS"
echo "Execution Role이 이미 존재합니다: $EXEC_ROLE_ARN"
fi

# Task Role 생성 (S3, DynamoDB, Cognito, IoT 사용)
echo "Task Role 확인 중..."
TASK_ROLE_EXISTS=$(aws iam get-role --role-name "$TASK_ROLE_NAME" --query "Role.Arn" --output text 2>/dev/null)

if [[ -z "$TASK_ROLE_EXISTS" ]]; then
echo "Task Role이 존재하지 않습니다. 생성 중..."
TASK_ROLE_ARN=$(aws iam create-role \
    --role-name "$TASK_ROLE_NAME" \
    --assume-role-policy-document "file://$ROLE_FILE" \
    --query "Role.Arn" --output text)
echo "Task Role 생성 완료: $TASK_ROLE_ARN"

# Task Role에 S3, DynamoDB, Cognito, IoT 권한 연결
aws iam attach-role-policy \
    --role-name "$TASK_ROLE_NAME" \
    --policy-arn "arn:aws:iam::aws:policy/AmazonS3FullAccess"
aws iam attach-role-policy \
    --role-name "$TASK_ROLE_NAME" \
    --policy-arn "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
aws iam attach-role-policy \
    --role-name "$TASK_ROLE_NAME" \
    --policy-arn "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
aws iam attach-role-policy \
    --role-name "$TASK_ROLE_NAME" \
    --policy-arn "arn:aws:iam::aws:policy/AWSIoTFullAccess"
echo "Task Role에 S3, DynamoDB, Cognito, IoT 권한 연결 완료."
else
TASK_ROLE_ARN="$TASK_ROLE_EXISTS"
echo "Task Role이 이미 존재합니다: $TASK_ROLE_ARN"
fi