module "db_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = var.namespace
  name      = "db"
  stage     = var.environment
  tags      = local.tags
}

resource "random_password" "admin_password" {
  length  = var.database.admin_password_length
  special = true
}

module "rds_mysql" {
  source  = "cloudposse/rds-cluster/aws"
  version = "1.5.0"
  enabled = true

  context         = module.db_label.context
  engine          = var.database.engine
  engine_mode     = var.database.engine_mode
  engine_version  = var.database.engine_version
  cluster_family  = var.database.cluster_family
  cluster_size    = var.database.cluster_size
  admin_user      = var.database.admin_user
  admin_password  = random_password.admin_password.result
  db_name         = var.database.name
  db_port         = var.database.db_port
  instance_type   = var.database.instance_type
  vpc_id          = module.vpc.vpc_id
  security_groups = [module.eks_cluster.eks_cluster_managed_security_group_id]
  subnets         = module.subnets.private_subnet_ids

  scaling_configuration = var.database.scaling_configuration
  tags                  = local.tags
}
