environment = "prod"
subnets = {
  nat_gateways_count = 1
}
database = {
  name           = "invodb"
  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.08.3"
  cluster_family = "aurora-mysql5.7"
  cluster_size   = 0
  scaling_configuration = [{
    auto_pause               = true
    max_capacity             = 4
    min_capacity             = 1
    seconds_until_auto_pause = 300
  }]
}