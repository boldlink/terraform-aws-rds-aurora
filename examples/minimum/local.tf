locals {
  cluster_name              = "example-minimum-aurora-cluster"
  supporting_resources_name = "terraform-aws-rds-aurora"
  tags = {
    Name               = local.cluster_name
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    Department         = "operations"
    InstanceScheduler  = true
    Project            = "aws-rds"
    Owner              = "hugo.almeida"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}
