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
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = "exampledb"
}

module "primary_cluster" {
  source = "../../"
  #checkov:skip=CKV_AWS_96:Ensure all data stored in Aurora is securely encrypted at rest
  #checkov:skip=CKV2_AWS_27: "Ensure Postgres RDS as aws_rds_cluster has Query Logging enabled"
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  instance_count                  = 1
  availability_zones              = data.aws_availability_zones.available.names
  global_cluster_identifier       = local.global_cluster_identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  port                            = var.port
  performance_insights_enabled    = true
  ca_cert_identifier              = var.ca_cert_identifier
  create_cluster_endpoint         = true
  custom_endpoint_type            = "ANY"
  min_capacity                    = 1
  max_capacity                    = 3
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.large"
  subnet_ids                      = data.aws_subnets.database.ids
  cluster_identifier              = "${local.cluster_name}-primary"
  master_username                 = random_string.master_username.result
  master_password                 = random_password.master_password.result
  final_snapshot_identifier       = "${local.cluster_name}-snapshot"
  vpc_id                          = data.aws_vpc.supporting.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  tags                            = merge({ "Name" = local.cluster_name }, var.tags)
  ingress_rules = {
    default = {
      from_port   = var.port
      to_port     = var.port
      cidr_blocks = [local.cidr_block]
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
  iam_database_authentication_enabled = true
  deletion_protection                 = false
  create_db_subnet_group              = true
  create_monitoring_role              = true
  allow_major_version_upgrade         = true
  auto_minor_version_upgrade          = true
  apply_immediately                   = true
  publicly_accessible                 = false
  backup_retention_period             = 30
  enable_global_write_forwarding      = true
  preferred_backup_window             = "01:00-03:00"
  preferred_maintenance_window        = "Sun:03:00-Sun:06:00"
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
  scale_in_cooldown      = 500
  scale_out_cooldown     = 500
  cluster_timeouts = {
    create = "30m"
    delete = "30m"
  }
  instance_timeouts = {
    create = "30m"
    delete = "30m"
  }
}

###
module "secondary_vpc" {
  source                  = "boldlink/vpc/aws"
  version                 = "3.0.4"
  name                    = "${local.supporting_resources_name}.sec"
  cidr_block              = local.secondary_cidr_block
  enable_internal_subnets = true

  internal_subnets = {
    databases = {
      cidrs = local.database_subnets
    }
  }
  tags = var.tags

  providers = {
    aws = aws.secondary
  }
}

###

module "secondary_cluster" {
  source = "../../"
  #checkov:skip=CKV_AWS_96:Ensure all data stored in Aurora is securely encrypted at rest
  #checkov:skip=CKV_AWS_128:Ensure that an Amazon RDS Clusters have AWS Identity and Access Management (IAM) authentication enabled
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  #checkov:skip=CKV_AWS_162:Ensure RDS cluster has IAM authentication enabled
  #checkov:skip=CKV_AWS_118:Ensure that enhanced monitoring is enabled for Amazon RDS instances
  #checkov:skip=CKV2_AWS_8:Ensure that RDS clusters has backup plan of AWS Backup
  #checkov:skip=CKV2_AWS_27: "Ensure Postgres RDS as aws_rds_cluster has Query Logging enabled"
  primary_cluster                     = false
  instance_count                      = 1
  availability_zones                  = data.aws_availability_zones.secondary.names
  global_cluster_identifier           = local.global_cluster_identifier
  engine                              = var.engine
  engine_version                      = var.engine_version
  port                                = var.port
  ca_cert_identifier                  = var.ca_cert_identifier
  engine_mode                         = "provisioned"
  instance_class                      = "db.r5.large"
  cluster_identifier                  = "${local.cluster_name}-secondary"
  skip_final_snapshot                 = true
  vpc_id                              = module.secondary_vpc.vpc_id
  subnet_ids                          = flatten(local.internal_subnet_ids)
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  create_db_subnet_group              = true
  tags                                = merge({ "Name" = local.cluster_name }, var.tags)
  iam_database_authentication_enabled = true
  replication_source_identifier       = module.primary_cluster.arn

  providers = {
    aws = aws.secondary
  }

  depends_on = [
    module.primary_cluster
  ]
}


resource "aws_backup_vault" "this" {
  name          = "${local.cluster_name}-backup-vault"
  force_destroy = true
  kms_key_arn   = data.aws_kms_key.supporting.arn
  tags          = var.tags
}

resource "aws_backup_plan" "this" {
  name = "${local.cluster_name}-backup-plan"
  rule {
    rule_name         = "${local.cluster_name}-backup-rule"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 14
    }
  }
}

resource "aws_backup_selection" "this" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${local.cluster_name}-backup-selection"
  plan_id      = aws_backup_plan.this.id

  resources = [
    module.primary_cluster.arn
  ]
}

resource "aws_iam_role" "backup" {
  name               = "${local.cluster_name}-backup-selection-role"
  assume_role_policy = data.aws_iam_policy_document.backup.json
}

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}
