locals {
  cluster_name     = "minimum-cluster-aurora-mysql"
  supporting_resources_name = "terraform-aws-rds-aurora"
    tags = {
      Name = local.cluster_name
    }
}
