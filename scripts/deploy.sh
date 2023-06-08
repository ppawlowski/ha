#!/bin/bash
set -e

CONFIRMATION_REQUIRED=$1
ENVIRONMENT_NAME=$2
TARGET=$3
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

if [ "$CONFIRMATION_REQUIRED" = "false" ]; then
  AUTO_APPROVE="-auto-approve"
else
  AUTO_APPROVE=""
fi

if [[ "${TARGET}" == "" ]] ; then
  echo "Deploying ${ENVIRONMENT_NAME} environment"
  terraform -chdir="${infrastructure_directory}" apply -var-file="./vars/${ENVIRONMENT_NAME}/${var_file_name}" ${AUTO_APPROVE}
else
  echo "Deploying single target ${TARGET} in ${ENVIRONMENT_NAME} environment"
  terraform -chdir="${infrastructure_directory}" apply -var-file="./vars/${ENVIRONMENT_NAME}/${var_file_name}" ${AUTO_APPROVE} -target "${TARGET}"
fi
