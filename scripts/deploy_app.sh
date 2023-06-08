#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

kubectl apply -k ${application_directory}/manifests
URL=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{$.status.loadBalancer.ingress[0].hostname}')

log_info "Application is available at http://${URL}"