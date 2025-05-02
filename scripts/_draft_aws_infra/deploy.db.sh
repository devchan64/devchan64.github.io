#! /bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source $SCRIPT_DIR/config.sh
source $SCRIPT_DIR/helper.sh

# Helper functions
log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

show_help() {
    echo "Usage: $0 {deploy|undeploy|help}"
    echo ""
    echo "Commands:"
    echo "  deploy      Deploy the DynamoDB table."
    echo "  undeploy    Delete the DynamoDB table."
    echo "  help        Show this help message."
    echo ""    
}

check_table_exists() {
    local table_name=$1
    if aws dynamodb describe-table --table-name "$table_name" --region "$REGION" $AWS_CLI_OPTS >/dev/null 2>&1; then
        return 0 # Table exists
    else
        return 1 # Table does not exist
    fi
}

wait_for_table_deletion() {
    local table_name=$1
    log "$table_name 테이블 삭제 완료를 기다리는 중..."
    while check_table_exists "$table_name"; do
        sleep 5
        log "$table_name 테이블이 아직 삭제 중입니다. 다시 시도합니다..."
    done
    log "$table_name 테이블이 성공적으로 삭제되었습니다."
}

deploy_table() {
    local table_name=$1
    local create_command=$2

    log "$table_name 테이블을 생성합니다..."
    if check_table_exists "$table_name"; then
        log "$table_name 테이블이 이미 존재합니다. 생성을 건너뜁니다."
    else
        eval "$create_command" | jq '.' || error "$table_name 테이블 생성 실패"
        log "$table_name 테이블이 성공적으로 생성되었습니다."
    fi
}

deploy() {
    # Create Documents Table
    deploy_table "$DOC_DYNAMO_TB_NAME" "aws dynamodb create-table \
        --table-name $DOC_DYNAMO_TB_NAME \
        --attribute-definitions AttributeName=documentId,AttributeType=S \
        --key-schema AttributeName=documentId,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region $REGION $AWS_CLI_OPTS"

    # Create Revisions Table
    deploy_table "$REVISION_DYNAMO_TB_NAME" "aws dynamodb create-table \
        --table-name $REVISION_DYNAMO_TB_NAME \
        --attribute-definitions AttributeName=revisionId,AttributeType=S AttributeName=documentId,AttributeType=S AttributeName=version,AttributeType=N \
        --key-schema AttributeName=revisionId,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --global-secondary-indexes '[
            {
                \"IndexName\": \"DocumentIndex\",
                \"KeySchema\": [
                    {\"AttributeName\": \"documentId\", \"KeyType\": \"HASH\"},
                    {\"AttributeName\": \"version\", \"KeyType\": \"RANGE\"}
                ],
                \"Projection\": {\"ProjectionType\": \"ALL\"}
            }
        ]' \
        --region $REGION $AWS_CLI_OPTS"

    # Create DocumentSubscriptions Table
    deploy_table "$SUBSCRIPTIONS_DYNAMO_TB_NAME" "aws dynamodb create-table \
        --table-name $SUBSCRIPTIONS_DYNAMO_TB_NAME \
        --attribute-definitions AttributeName=documentId,AttributeType=S AttributeName=userID,AttributeType=S \
        --key-schema AttributeName=userID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --global-secondary-indexes '[
            {
                \"IndexName\": \"DocumentSubscriptionIndex\",
                \"KeySchema\": [
                    {\"AttributeName\": \"documentId\", \"KeyType\": \"HASH\"}
                ],
                \"Projection\": {\"ProjectionType\": \"ALL\"}
            }
        ]' \
        --region $REGION $AWS_CLI_OPTS"
}

undeploy() {
    for table_name in "$DOC_DYNAMO_TB_NAME" "$REVISION_DYNAMO_TB_NAME" "$SUBSCRIPTIONS_DYNAMO_TB_NAME"; do
        log "$table_name 테이블 삭제를 시작합니다..."
        if check_table_exists "$table_name"; then
            aws dynamodb delete-table --table-name "$table_name" --region "$REGION" $AWS_CLI_OPTS || error "$table_name 테이블 삭제 실패"
            wait_for_table_deletion "$table_name"
        else
            log "$table_name 테이블이 존재하지 않습니다. 삭제를 건너뜁니다."
        fi
    done
}

# 스크립트를 단독 실행할 때만 check_dependencies와 exec 실행
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  check_dependencies
  exec "$@"
fi