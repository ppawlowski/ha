#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=${1}
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

cd "${infrastructure_directory}"
tfenv install
tfenv use $(tfenv version-name)
