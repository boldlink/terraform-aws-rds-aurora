# ###################################
#  Aurora-mysql serverless example
# ###################################

locals {
  cluster_name = "sample-cluster-serverless"
  environment  = "test"
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

module "kms_key" {
  source              = "boldlink/kms-key/aws"
  version             = "1.0.0"
  description         = "A test kms key for RDS cluster"
  name                = "${local.cluster_name}-key"
  alias_name          = "alias/aurora-serverless-key-alias"
  enable_key_rotation = true
}

module "aurora_serverless" {
  source                = "./../../"
  instance_count        = 0
  engine                = "aurora-mysql"
  engine_version        = "5.7"
  port                  = 3306
  engine_mode           = "serverless"
  instance_class        = "db.r5.2xlarge"
  subnet_ids            = data.aws_subnets.default.ids
  cluster_identifier    = local.cluster_name
  master_username       = random_string.master_username.result
  master_password       = random_password.master_password.result
  storage_encrypted     = true
  kms_key_id            = join("", module.kms_key.*.arn)
  vpc_id                = data.aws_vpc.default.id
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


  environment                    = local.environment
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

output "rds_serverless_output" {
  value = [
    module.aurora_serverless,
  ]
}