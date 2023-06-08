#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
CONFIRMATION_REQUIRED=$2
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

if [ "$CONFIRMATION_REQUIRED" = "false" ]; then
  AUTO_APPROVE="-auto-approve"
else
  AUTO_APPROVE=""
fi

echo "Destroying ${ENVIRONMENT_NAME} environment"
terraform -chdir="${infrastructure_directory}" destroy -var-file="./vars/${ENVIRONMENT_NAME}/${var_file_name}" ${AUTO_APPROVE}
