#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"


uninstall_ingress_nginx() {
  helm uninstall ingress-nginx --namespace ingress-nginx
}

main() {
  uninstall_ingress_nginx
}

main
