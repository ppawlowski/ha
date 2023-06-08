output "region" {
  value = var.region
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "registry_name" {
  description = "The name of the ECR repository"
  value       = module.ecr.repository_url
}

output "db_user" {
  description = "The username of the RDS instance"
  value       = module.rds_mysql.master_username
  sensitive   = true
}

output "db_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "db_host" {
  description = "The hostname of the RDS instance"
  value       = module.rds_mysql.endpoint
}

output "db_name" {
  description = "The name of the RDS database"
  value       = module.rds_mysql.database_name
}
