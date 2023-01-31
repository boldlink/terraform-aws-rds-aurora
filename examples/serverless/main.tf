####################################
#  Aurora-mysql serverless example
####################################

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

module "aurora_serverless" {
  source = "../../"
  #checkov:skip=CKV_AWS_128:Ensure that an Amazon RDS Clusters have AWS Identity and Access Management (IAM) authentication enabled
  #checkov:skip=CKV_AWS_162:Ensure RDS cluster has IAM authentication enabled
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  instance_count        = 0
  engine                = "aurora-mysql"
  engine_version        = "5.7"
  port                  = 3306
  engine_mode           = "serverless"
  instance_class        = "db.r5.2xlarge"
  subnet_ids            = data.aws_subnets.database.ids
  cluster_identifier    = local.cluster_name
  master_username       = random_string.master_username.result
  master_password       = random_password.master_password.result
  storage_encrypted     = true
  kms_key_id            = data.aws_kms_key.supporting.arn
  vpc_id                = data.aws_vpc.supporting.id
  enable_http_endpoint  = true
  create_security_group = true
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


  tags                           = local.tags
  deletion_protection            = false
  skip_final_snapshot            = true
  create_monitoring_role         = true
  monitoring_interval            = 30
  assume_role_policy             = data.aws_iam_policy_document.monitoring.json
  policy_arn                     = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  create_cluster_parameter_group = true
  family                         = "aurora-mysql5.7"
  cluster_parameters = [
    {
      name         = "character_set_server"
      value        = "utf8"
      apply_method = "immediate"
    }
  ]
  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 256
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_backup_vault" "this" {
  name          = "${local.cluster_name}-backup-vault"
  kms_key_arn = data.aws_kms_key.supporting.arn
  tags          = local.tags
}

resource "aws_backup_plan" "this" {
  name  = "${local.cluster_name}-backup-plan"
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
    module.aurora_serverless.arn
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