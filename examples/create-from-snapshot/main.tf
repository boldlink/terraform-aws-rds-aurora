###################################
#  replication example
###################################

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

# Example External security Group
resource "aws_security_group" "external" {
  name        = "${local.cluster_name}-sg-external"
  description = "Allow rds traffic"
  vpc_id      = data.aws_vpc.supporting.id

  ingress {
    description      = "Ingress from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [local.vpc_cidr]
  }

  egress {
    description      = "Example Egress rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

module "rds_cluster" {
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  #checkov:skip=CKV_AWS_118:Ensure that enhanced monitoring is enabled for Amazon RDS instances
  #checkov:skip=CKV2_AWS_8:Ensure that RDS clusters has backup plan of AWS Backup
  source                          = "../../"
  instance_count                  = 1
  availability_zones              = data.aws_availability_zones.available.names
  engine                          = "aurora-mysql"
  engine_version                  = "5.7"
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.large"
  subnet_ids                      = data.aws_subnets.database.ids
  cluster_identifier              = local.cluster_name
  master_username                 = random_string.master_username.result
  master_password                 = random_password.master_password.result
  storage_encrypted               = true
  kms_key_id                      = data.aws_kms_key.supporting.arn
  vpc_id                          = data.aws_vpc.supporting.id
  tags                            = local.tags
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  vpc_security_group_ids          = [ aws_security_group.external.id ]
  ingress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
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
  assume_role_policy                  = data.aws_iam_policy_document.monitoring.json
  family                              = "aurora-mysql5.7"
}


resource "aws_db_cluster_snapshot" "example" {
  #checkov:skip=CKV_AWS_146: "Ensure that RDS database cluster snapshot is encrypted"
  db_cluster_identifier         = module.rds_cluster.id
  db_cluster_snapshot_identifier = "${local.cluster_name}-snapshot"
  tags                           = local.tags
}


### Create cluster from a snapshot

module "snapshot_cluster" {
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  #checkov:skip=CKV_AWS_118:Ensure that enhanced monitoring is enabled for Amazon RDS instances
  #checkov:skip=CKV2_AWS_8:Ensure that RDS clusters has backup plan of AWS Backup
  source                          = "../../"
  snapshot_identifier             = aws_db_cluster_snapshot.example.db_cluster_snapshot_arn
  instance_count                  = 1
  availability_zones              = data.aws_availability_zones.available.names
  engine                          = "aurora-mysql"
  engine_version                  = "5.7"
  port                            = 3306
  engine_mode                     = "provisioned"
  instance_class                  = "db.r5.large"
  subnet_ids                      = data.aws_subnets.database.ids
  cluster_identifier              = "${local.cluster_name}-new"
  storage_encrypted               = true
  kms_key_id                      = data.aws_kms_key.supporting.arn
  vpc_id                          = data.aws_vpc.supporting.id
  tags                            = local.tags
  manage_master_user_password     = false
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  ingress_rules = {
    default = {
      from_port   = 3306
      to_port     = 3306
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
  family                              = "aurora-mysql5.7"

  depends_on = [module.rds_cluster, aws_db_cluster_snapshot.example]
}
