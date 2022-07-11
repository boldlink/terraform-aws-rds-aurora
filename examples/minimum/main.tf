###################################
#  Min Aurora-mysql example
###################################
module "vpc" {
  source               = "git::https://github.com/boldlink/terraform-aws-vpc.git?ref=2.0.3"
  cidr_block           = local.cidr_block
  name                 = local.cluster_name
  enable_dns_support   = true
  enable_dns_hostnames = true
  account              = data.aws_caller_identity.current.account_id
  region               = data.aws_region.current.name

  ## database Subnets
  database_subnets   = local.database_subnets
  availability_zones = local.azs
}

resource "random_string" "master_username" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

resource "random_password" "master_password" {
  length  = 16
  special = false
  upper   = false
}

module "minimum" {
  source = "../../"
  #checkov:skip=CKV_AWS_96:Ensure all data stored in Aurora is securely encrypted at rest
  #checkov:skip=CKV_AWS_128:Ensure that an Amazon RDS Clusters have AWS Identity and Access Management (IAM) authentication enabled
  #checkov:skip=CKV_AWS_162:Ensure RDS cluster has IAM authentication enabled
  #checkov:skip=CKV_AWS_118:Ensure that enhanced monitoring is enabled for Amazon RDS instances
  instance_count      = 1
  engine              = "aurora-mysql"
  port                = 3306
  instance_class      = "db.r5.2xlarge"
  subnet_ids          = flatten(module.vpc.database_subnet_id)
  cluster_identifier  = local.cluster_name
  master_username     = random_string.master_username.result
  master_password     = random_password.master_password.result
  vpc_id              = module.vpc.id
  skip_final_snapshot = true
  deletion_protection = false
}
