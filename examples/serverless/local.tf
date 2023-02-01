locals {
  cluster_name              = "sample-cluster-serverless"
  supporting_resources_name = "terraform-aws-rds-aurora"
  tags = {
    Name               = local.cluster_name
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    department         = "operations"
    InstanceScheduler  = true
    Project            = "aws-rds"
    Owner              = "hugo.almeida"
    LayerName          = "c550-aws-rds-cluster"
    LayerId            = "c550"
  }
}
