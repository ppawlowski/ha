#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"

region=$(terraform -chdir="${infrastructure_directory}" output -raw "region")
eks_cluster_name=$(terraform -chdir="${infrastructure_directory}" output -raw "eks_cluster_name")

aws eks --region "${region}" update-kubeconfig --name "${eks_cluster_name}"
