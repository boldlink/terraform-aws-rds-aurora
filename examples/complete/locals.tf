locals {
  cluster_name              = "sample-global-aurora-cluster"
  environment               = "test"
  engine                    = "aurora"
  engine_version            = "5.6.mysql_aurora.1.22.2"
  global_cluster_identifier = local.cluster_name
  cidr_block                = "172.16.0.0/16"
  database_subnets          = cidrsubnets(local.cidr_block, 8, 8, 8)
  azs                       = flatten(data.aws_availability_zones.available.names)
  secondary_azs             = flatten(data.aws_availability_zones.secondary.names)
}
