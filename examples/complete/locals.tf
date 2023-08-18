locals {
  cluster_name              = "sample-global-aurora-cluster"
  supporting_resources_name = "terraform-aws-rds-aurora"
  engine                    = "aurora-mysql"
  engine_version            = "5.7.mysql_aurora.2.11.3"
  global_cluster_identifier = local.cluster_name
  cidr_block                = "172.16.0.0/16"
  internal_subnet_ids       = data.aws_subnets.internal.ids
  database_subnets          = cidrsubnets(local.cidr_block, 8, 8, 8)
  dns_suffix                = data.aws_partition.current.dns_suffix

  tags = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    Department         = "operations"
    InstanceScheduler  = true
    Project            = "aws-rds"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}
