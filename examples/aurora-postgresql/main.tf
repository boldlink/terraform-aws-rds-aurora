
# ##########################
#  Aurora-postgresql example
# ##########################
locals {
  cluster_name = "sample-cluster-aurora"
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
  alias_name          = "alias/rds-key-alias"
  enable_key_rotation = true
}

module "rds_cluster" {
  source                          = "./../../"
  instance_count                  = 1
  engine                          = "aurora-postgresql"
  engine_version                  = "11.12"
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.2xlarge"
  subnet_ids                      = data.aws_subnets.default.ids
  cluster_identifier              = local.cluster_name
  master_username                 = random_string.master_username.result
  master_password                 = random_password.master_password.result
  final_snapshot_identifier       = "${local.cluster_name}-snapshot-${uuid()}"
  storage_encrypted               = true
  kms_key_id                      = join("", module.kms_key.*.arn)
  vpc_id                          = data.aws_vpc.default.id
  enabled_cloudwatch_logs_exports = ["postgresql"]
  create_security_group           = true
  ingress_rules = {
    default = {
      from_port = 5432
      to_port   = 5432
    }

  }
  egress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  sg_name                             = "${local.cluster_name}-securitygroup-${uuid()}"
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
  family                              = "aurora-postgresql11"
  enable_autoscaling                  = true
  scalable_dimension                  = "rds:cluster:ReadReplicaCount"
  policy_type                         = "TargetTrackingScaling"
  predefined_metric_type              = "RDSReaderAverageCPUUtilization"
}

output "rds_cluster_output" {
  value = [
    module.rds_cluster,
  ]
}
