locals {
  cluster_name              = "sample-cluster-aurora-mysql"
  supporting_resources_name = "terraform-aws-rds-aurora"
  tags = {
    Name = local.cluster_name
  }
}
