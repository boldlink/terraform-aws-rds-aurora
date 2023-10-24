###########################
#  Aurora-postgresql example
###########################

resource "random_string" "master_username" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

module "rds_cluster" {
  #checkov:skip=CKV2_AWS_27: "Ensure Postgres RDS as aws_rds_cluster has Query Logging enabled"
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  source                          = "../../"
  instance_count                  = 1
  availability_zones              = data.aws_availability_zones.available.names
  engine                          = "aurora-postgresql"
  engine_version                  = "12.15"
  port                            = 5432
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  subnet_ids                      = data.aws_subnets.database.ids
  cluster_identifier              = local.cluster_name
  master_username                 = random_string.master_username.result
  final_snapshot_identifier       = "${local.cluster_name}-snapshot"
  storage_encrypted               = true
  kms_key_id                      = data.aws_kms_key.supporting.arn
  vpc_id                          = data.aws_vpc.supporting.id
  enabled_cloudwatch_logs_exports = ["postgresql"]
  ingress_rules = {
    default = {
      from_port   = 5432
      to_port     = 5432
      cidr_blocks = [local.vpc_cidr]
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
  create_cluster_endpoint             = true
  create_monitoring_role              = true
  monitoring_interval                 = 30
  assume_role_policy                  = data.aws_iam_policy_document.monitoring.json
  policy_arn                          = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  create_cluster_parameter_group      = true
  family                              = "aurora-postgresql11"
  enable_autoscaling                  = true
  scalable_dimension                  = "rds:cluster:ReadReplicaCount"
  policy_type                         = "TargetTrackingScaling"
  predefined_metric_type              = "RDSReaderAverageCPUUtilization"
  tags                                = local.tags
}

resource "aws_backup_vault" "this" {
  name          = "${local.cluster_name}-backup-vault"
  force_destroy = true
  kms_key_arn   = data.aws_kms_key.supporting.arn
  tags          = local.tags
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
    module.rds_cluster.arn
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
