# #####################################
#  Global cluster MySQL Aurora example
# #####################################

provider "aws" {
  alias  = "primary"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "secondary"
  region = "eu-west-2"
}

locals {
  cluster_name              = "sample-aurora-cluster"
  environment               = "test"
  engine                    = "aurora"
  engine_version            = "5.6.mysql_aurora.1.22.2"
  global_cluster_identifier = "${local.cluster_name}-global"
}

resource "random_string" "master_username" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

resource "random_password" "master_password" {
  length  = 16
  special = false
  upper   = false
}

module "global_cluster" {
  source                    = "./../../modules/global-cluster"
  create_global_cluster     = true
  global_cluster_identifier = local.global_cluster_identifier
  engine                    = local.engine
  engine_version            = local.engine_version
  database_name             = "random_db"
}

module "primary_cluster" {
  source                          = "./../../"
  instance_count                  = 1
  global_cluster_identifier       = local.global_cluster_identifier
  engine                          = local.engine
  engine_version                  = local.engine_version
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  subnet_ids                      = data.aws_subnets.default.ids
  cluster_identifier              = "${local.cluster_name}-primary"
  master_username                 = random_string.master_username.result
  master_password                 = random_password.master_password.result
  final_snapshot_identifier       = "${local.cluster_name}-snapshot-${uuid()}"
  vpc_id                          = data.aws_vpc.default.id
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
  create_db_subnet_group              = false
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

module "secondary_cluster" {
  source          = "./../../"
  primary_cluster = false
  providers = {
    aws = aws.secondary
  }
  instance_count                  = 1
  global_cluster_identifier       = local.global_cluster_identifier
  engine                          = local.engine
  engine_version                  = local.engine_version
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  cluster_identifier              = "${local.cluster_name}-secondary"
  skip_final_snapshot             = true
  vpc_id                          = data.aws_vpc.default.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  create_db_subnet_group          = false
  depends_on = [
    module.primary_cluster
  ]
}

output "aurora_global_cluster" {
  value = [
    module.primary_cluster,
    module.global_cluster
  ]
}