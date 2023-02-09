locals {
  cluster_name              = "sample-cluster-aurora-mysql"
  supporting_resources_name = "terraform-aws-rds-aurora"
  dns_suffix                = data.aws_partition.current.dns_suffix
  tags = {
    Name               = local.cluster_name
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    department         = "operations"
    InstanceScheduler  = true
    Project            = "aws-rds"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}
