#!/usr/bin/env bash
set -e

ENVIRONMENT_NAME=$1
script_directory=$(dirname "$0")
source "${script_directory}/config"
source "${script_directory}/functions.bash"
image_tag=$(date +%s)
repository_url=$(terraform -chdir="${infrastructure_directory}" output -raw "registry_name")


get_app_code() {
  if [ ! -d "${application_directory}/code" ] ; then
    log_info "Cloning application code"
    git clone git@github.com:asemhostaway/invo.git "${application_directory}/code"
  else
    log_info "Updating applocation code"
    git -C "${application_directory}/code" pull
  fi
}

build_image() {
  log_info "Building docker image"
  docker build -t invo:latest -f "${application_directory}/Dockerfile" "${application_directory}"
}

push_image() {
  log_info "Pushing docker image"
  docker tag invo:latest "${repository_url}:latest"
  docker tag invo:latest "${repository_url}:${image_tag}"
  docker push "${repository_url}:latest"
  docker push "${repository_url}:${image_tag}"
}

customize_deployment() {
  log_info "Updating image tag"
  sed -i.bak "s/newTag:.*/newTag: \'${image_tag}\'/" "${application_directory}/manifests/kustomization.yaml" 
  sed -i.bak "s#newName:.*#newName: ${repository_url}#" "${application_directory}/manifests/kustomization.yaml" 
  log_info "Updating envs"
  db_user=$(terraform -chdir="${infrastructure_directory}" output -raw "db_user")
  db_password=$(terraform -chdir="${infrastructure_directory}" output -raw "db_password")
  db_host=$(terraform -chdir="${infrastructure_directory}" output -raw "db_host")
  db_name=$(terraform -chdir="${infrastructure_directory}" output -raw "db_name")
  sed -i.bak "s/password=.*/password=\'${db_password}\'/" "${application_directory}/manifests/kustomization.yaml"
  sed -i.bak "s/user=.*/user=\'${db_user}\'/" "${application_directory}/manifests/kustomization.yaml"
  sed -i.bak "s/host=.*/host=\'${db_host}\'/" "${application_directory}/manifests/kustomization.yaml"
  sed -i.bak "s/database=.*/database=\'${db_name}\'/" "${application_directory}/manifests/kustomization.yaml"
  rm -f "${application_directory}/manifests/kustomization.yaml.bak"
}


main() {
  get_app_code
  build_image
  push_image
  customize_deployment
}

main
