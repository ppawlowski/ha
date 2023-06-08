#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=${1}
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

if [[ "${ENVIRONMENT_NAME}" == "" ]] ; then
  log_error "Environment name has not been set!"
  echo "Please use 'make set-environment' make target to set environment name."
  exit 1
fi

log_info "Current environment set in scripts: ${ENVIRONMENT_NAME}"
