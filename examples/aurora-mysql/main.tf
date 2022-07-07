###########################
#  Aurora-mysql example
###########################
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

module "kms_key" {
  source                  = "boldlink/kms/aws"
  description             = "A test kms key for RDS cluster"
  create_kms_alias        = true
  alias_name              = "alias/rds-key-alias"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags = {
    Name        = local.cluster_name
    Environment = local.environment
  }
}

module "rds_cluster" {
  source                          = "../../"
  instance_count                  = 1
  engine                          = "aurora-mysql"
  engine_version                  = "5.7"
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  subnet_ids                      = flatten(module.vpc.database_subnet_id)
  cluster_identifier              = local.cluster_name
  master_username                 = random_string.master_username.result
  master_password                 = random_password.master_password.result
  final_snapshot_identifier       = "${local.cluster_name}-snapshot-${uuid()}"
  storage_encrypted               = true
  kms_key_id                      = join("", module.kms_key.*.arn)
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
  create_cluster_endpoint             = true
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
