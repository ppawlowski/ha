variable "environment" {
  type = string
}

variable "namespace" {
  type    = string
  default = "ha"
}

variable "region" {
  default = "eu-west-1"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  type = object({
    nat_gateways_count = number
  })
  default = {
    nat_gateways_count = 3
  }
}

variable "eks" {
  type = object({
    kubernetes_version           = string
    min_size                     = number
    max_size                     = number
    desired_size                 = number
    instance_type                = string
    autoscaling_policies_enabled = bool
    vpc_cni_version              = string
    coredns_version              = string
    kube_proxy_version           = string
  })
  default = {
    kubernetes_version           = "1.26"
    min_size                     = 2
    max_size                     = 4
    desired_size                 = 2
    instance_type                = "t3.medium"
    autoscaling_policies_enabled = true
    vpc_cni_version              = "v1.12.6-eksbuild.2"
    coredns_version              = "v1.9.3-eksbuild.3"
    kube_proxy_version           = "v1.26.2-eksbuild.1"
  }
}

variable "database" {
  type = object({
    name                  = string
    engine                = string
    engine_mode           = optional(string, "serverless")
    engine_version        = string
    cluster_family        = string
    cluster_size          = number
    admin_user            = optional(string, "haadmin"),
    admin_password_length = optional(number, 16)
    db_port               = optional(number, 3306)
    instance_type         = optional(string, "db.t2.small")
    scaling_configuration = list(object({
      auto_pause               = optional(bool, true)
      min_capacity             = optional(number, 2)
      max_capacity             = optional(number, 265)
      seconds_until_auto_pause = optional(number, 300)
      timeout_action           = optional(string, "ForceApplyCapacityChange")
    }))
  })
}
