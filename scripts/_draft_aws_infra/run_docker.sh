#! /bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source $SCRIPT_DIR/config.sh

docker run -p 4000:4000 ${REPOSITORY_NAME}