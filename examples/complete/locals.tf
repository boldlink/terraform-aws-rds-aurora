locals {
  cluster_name              = "example-global-aurora-cluster"
  supporting_resources_name = "terraform-aws-rds-aurora"
  global_cluster_identifier = local.cluster_name
  secondary_cidr_block      = "172.16.0.0/16"
  internal_subnet_ids       = data.aws_subnets.internal.ids
  cidr_block                = data.aws_vpc.supporting.cidr_block
  database_subnets          = cidrsubnets(local.secondary_cidr_block, 8, 8, 8)
  dns_suffix                = data.aws_partition.current.dns_suffix
}
