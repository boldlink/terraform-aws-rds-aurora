locals {
  cluster_name     = "sample-cluster-serverless"
  supporting_resources_name = "terraform-aws-rds-aurora"
    tags = {
      Name = local.cluster_name
    }
}
