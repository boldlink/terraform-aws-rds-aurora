locals {
  cidr_block       = "10.1.0.0/16"
  database_subnets = [cidrsubnet(local.cidr_block, 8, 13), cidrsubnet(local.cidr_block, 8, 14), cidrsubnet(local.cidr_block, 8, 15)]
  name             = "terraform-aws-rds-aurora"

  tags = {
    Environment        = "examples"
    "user::CostCenter" = "terraform-registry"
    department         = "operations"
    Project            = "aws-vpc"
    Owner              = "hugo.almeida"
    LayerName          = "c300-aws-vpc"
    LayerId            = "c300"
  }
}
