
locals {
  cluster_name = "sample-rds-cluster"
  environment  = "test"
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "random_string" "master_username" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "master_password" {
  length  = 16
  special = false
  upper   = false
}

module "rds_subnet_group" {
  source      = "boldlink/db-subnet-group/aws"
  version     = "1.0.0"
  name        = "${local.cluster_name}-subnet-group-${uuid()}"
  subnet_ids  = data.aws_subnets.default.ids
  environment = local.environment
}

module "kms_key" {
  source              = "boldlink/kms-key/aws"
  version             = "1.0.0"
  description         = "A test kms key for RDS cluster"
  name                = "${local.cluster_name}-key"
  alias_name          = "alias/rds-key-alias"
  enable_key_rotation = true
}

module "rds_cluster" {
  source                              = "./../"
  cluster_identifier                  = "${local.cluster_name}-${uuid()}"
  master_username                     = random_string.master_username.result
  master_password                     = random_password.master_password.result
  final_snapshot_identifier           = "${local.cluster_name}-snapshot-${uuid()}"
  preferred_backup_window             = "02:00-03:00"
  preferred_maintenance_window        = "sun:06:00-sun:09:00"
  storage_encrypted                   = true
  kms_key_id                          = join("", module.kms_key.*.arn)
  vpc_id                              = data.aws_vpc.default.id
  db_subnet_group_name                = join("", module.rds_subnet_group.*.id)
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  create_security_group               = true
  sg_name                             = "${local.cluster_name}-securitygroup-${uuid()}"
  skip_final_snapshot                 = true
  environment                         = local.environment
  iam_database_authentication_enabled = true
  deletion_protection                 = true
}

output "rds_cluster_output" {
  value = [
    module.rds_cluster,
  ]
}