.DEFAULT_GOAL := help
CONFIRMATION_REQUIRED=true
ENVIRONMENT=prod

init: check-environment ## Initialize terraform environment
	@scripts/init.sh ${ENVIRONMENT}

plan: check-environment ## Dry-run infrastructure deployment
	@scripts/plan.sh ${ENVIRONMENT}

deploy: check-environment ## Perform infrastructure deployment
	@scripts/deploy.sh ${CONFIRMATION_REQUIRED} ${ENVIRONMENT} ${target}

destroy: check-environment ## Destroy infrastructure environment
	@scripts/destroy.sh ${ENVIRONMENT} ${CONFIRMATION_REQUIRED}

destroy-all: destroy-kubernetes destroy ## Destroy infrastructure environment
	@scripts/destroy.sh ${ENVIRONMENT} ${CONFIRMATION_REQUIRED}

lint: check-environment ## Lint terraform code
	@scripts/lint.sh ${ENVIRONMENT}

get-kubeconfig: check-environment ## Get kubeconfig
	@scripts/get_kubeconfig.sh ${ENVIRONMENT}

deploy-kubernetes: check-environment get-kubeconfig ## Deploy kubernetes-related resources
	@scripts/deploy_kubernetes.sh ${ENVIRONMENT}

destroy-kubernetes: check-environment get-kubeconfig ## Destroy kubernetes-related resources
	@scripts/destroy_kubernetes.sh ${ENVIRONMENT}

build-app: check-environment ## Build application
	@scripts/build_app.sh

deploy-app: get-kubeconfig ## Deploy application
	@scripts/deploy_app.sh ${ENVIRONMENT}

check-environment: check-tools ## Checks if proper environment variables are set
	@scripts/check_environment.sh ${ENVIRONMENT}

set-environment: ## Sets proper environment for further scripts execution
	@scripts/set_environment.sh ${env}

prepare-terraform: ## Installs terraform version according to .terraform-version
	@scripts/prepare_terraform.sh ${ENVIRONMENT}

check-tools: ## Checks if required tools are installed
	@scripts/check_tools.sh

deploy-all: check-environment deploy deploy-kubernetes build-app deploy-app ## Deploy everything

help: ## This help message
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
