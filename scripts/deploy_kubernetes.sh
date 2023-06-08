#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

install_ingress_nginx() {
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace \
    --values "${script_directory}/../kubernetes/vars/ingress-nginx/${ENVIRONMENT_NAME}.yaml"
}

main() {
  install_ingress_nginx
}

main
