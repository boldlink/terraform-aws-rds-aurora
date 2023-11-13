locals {
  cluster_name              = "example-serverless-cluster"
  supporting_resources_name = "terraform-aws-rds-aurora"
  dns_suffix                = data.aws_partition.current.dns_suffix
  vpc_cidr                  = data.aws_vpc.supporting.cidr_block
  tags = {
    Name               = local.cluster_name
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
