module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace  = var.namespace
  name       = "eks"
  stage      = var.environment
  attributes = ["cluster"]
  tags       = local.tags
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  context = module.label.context

  ipv4_primary_cidr_block          = var.cidr
  assign_generated_ipv6_cidr_block = false

  tags = local.tags
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.3.0"

  context              = module.label.context
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  max_nats             = var.subnets.nat_gateways_count

  tags = local.tags
}

module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "2.8.1"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids

  kubernetes_version    = var.eks.kubernetes_version
  oidc_provider_enabled = true

  addons = [
    {
      addon_name               = "vpc-cni"
      addon_version            = var.eks.vpc_cni_version
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    },
    {
      addon_name               = "kube-proxy"
      addon_version            = var.eks.kube_proxy_version
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    },
    {
      addon_name               = "coredns"
      addon_version            = var.eks.coredns_version
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    }
  ]
  addons_depends_on = [module.eks_node_group]

  context = module.label.context

  cluster_depends_on = [module.subnets]
}

module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "2.10.0"

  instance_types             = [var.eks.instance_type]
  subnet_ids                 = module.subnets.public_subnet_ids
  min_size                   = var.eks.min_size
  max_size                   = var.eks.max_size
  desired_size               = var.eks.desired_size
  cluster_name               = module.eks_cluster.eks_cluster_id
  cluster_autoscaler_enabled = var.eks.autoscaling_policies_enabled

  context = module.label.context

  module_depends_on = module.eks_cluster.kubernetes_config_map_id
}

module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.38.0"

  context                = module.label.context
  name                   = "ecr"
  image_names            = ["invo"]
  force_delete           = true
  principals_full_access = [module.eks_cluster.eks_cluster_role_arn]
}