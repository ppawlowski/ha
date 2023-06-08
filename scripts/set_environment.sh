#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=${1}
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

check_environment() {
  if [[ "${ENVIRONMENT_NAME}" == "" ]] ; then
    log_error "Environment name has not been set!"
    echo "Please pass an environment name as an argument"
    echo ""
    echo "Example usage: "
    echo "  make set-environment env=example-environment-name"
    echo ""
    exit 1
  fi
  if [[ ! " ${environments[*]} " =~ " ${ENVIRONMENT_NAME} " ]]; then
    log_error "Environment name is not valid!"
    echo "Please pass a valid environment name as an argument"
    echo "Available environments: ${environments[*]}"
    exit 1
fi
}

set_environment_in_makefile() {
  sed -i.bak "s/^ENVIRONMENT=.*/ENVIRONMENT=${ENVIRONMENT_NAME}/" Makefile
  rm -f Makefile.bak
}

main() {
  check_environment
  set_environment_in_makefile
}

main
