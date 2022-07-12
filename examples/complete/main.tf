###################################################################
# Complete example with Global cluster MySQL Aurora example
###################################################################
provider "aws" {
  alias  = "primary"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "secondary"
  region = "eu-west-2"
}

module "vpc" {
  source               = "git::https://github.com/boldlink/terraform-aws-vpc.git?ref=2.0.3"
  cidr_block           = local.cidr_block
  name                 = "${local.cluster_name}.pri"
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

module "global_cluster" {
  source                    = "../../modules/global-cluster"
  create_global_cluster     = true
  global_cluster_identifier = local.global_cluster_identifier
  engine                    = local.engine
  engine_version            = local.engine_version
  database_name             = "random_db"
}

module "primary_cluster" {
  source = "../../"
  #checkov:skip=CKV_AWS_96:Ensure all data stored in Aurora is securely encrypted at rest
  instance_count                  = 1
  global_cluster_identifier       = local.global_cluster_identifier
  engine                          = local.engine
  engine_version                  = local.engine_version
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  subnet_ids                      = flatten(module.vpc.database_subnet_id)
  cluster_identifier              = "${local.cluster_name}-primary"
  master_username                 = random_string.master_username.result
  master_password                 = random_password.master_password.result
  final_snapshot_identifier       = "${local.cluster_name}-snapshot-${uuid()}"
  vpc_id                          = module.vpc.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  create_security_group           = true
  ingress_rules = {
    default = {
      from_port = 3306
      to_port   = 3306
    }
  }
  egress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  skip_final_snapshot                 = true
  environment                         = local.environment
  iam_database_authentication_enabled = true
  deletion_protection                 = false
  create_db_subnet_group              = true
  create_monitoring_role              = true
  monitoring_interval                 = 30
  assume_role_policy                  = data.aws_iam_policy_document.monitoring.json
  policy_arn                          = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  create_cluster_parameter_group      = true
  family                              = "aurora-mysql5.7"
  cluster_parameters = [
    {
      name         = "character_set_server"
      value        = "utf8"
      apply_method = "immediate"
    }
  ]
  enable_autoscaling     = true
  scalable_dimension     = "rds:cluster:ReadReplicaCount"
  policy_type            = "TargetTrackingScaling"
  predefined_metric_type = "RDSReaderAverageCPUUtilization"
}

module "secondary_vpc" {
  source               = "git::https://github.com/boldlink/terraform-aws-vpc.git?ref=2.0.3"
  cidr_block           = local.cidr_block
  name                 = "${local.cluster_name}.sec"
  enable_dns_support   = true
  enable_dns_hostnames = true
  account              = data.aws_caller_identity.current.account_id
  region               = data.aws_region.secondary.name

  ## database Subnets
  database_subnets   = local.database_subnets
  availability_zones = local.secondary_azs

  providers = {
    aws = aws.secondary
  }
}

module "secondary_cluster" {
  source = "../../"
  #checkov:skip=CKV_AWS_96:Ensure all data stored in Aurora is securely encrypted at rest
  #checkov:skip=CKV_AWS_128:Ensure that an Amazon RDS Clusters have AWS Identity and Access Management (IAM) authentication enabled
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  #checkov:skip=CKV_AWS_162:Ensure RDS cluster has IAM authentication enabled
  #checkov:skip=CKV_AWS_118:Ensure that enhanced monitoring is enabled for Amazon RDS instances
  primary_cluster                 = false
  instance_count                  = 1
  global_cluster_identifier       = local.global_cluster_identifier
  engine                          = local.engine
  engine_version                  = local.engine_version
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  cluster_identifier              = "${local.cluster_name}-secondary"
  skip_final_snapshot             = true
  vpc_id                          = module.secondary_vpc.id
  subnet_ids                      = flatten(module.secondary_vpc.database_subnet_id)
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  create_db_subnet_group          = true

  providers = {
    aws = aws.secondary
  }

  depends_on = [
    module.primary_cluster
  ]
}
