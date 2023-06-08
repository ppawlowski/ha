#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

check_tool() {
  if ! command -v "$1" &>/dev/null; then
    log_error "$1 is not installed."
    return 1
  fi
}

main() {
  log_info "Checking tools..."
  for tool in "${required_tools[@]}"; do
    check_tool "$tool"
  done
}

main
