###################################
#  Min Aurora-mysql example
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

module "minimum" {
  source = "../../"
  #checkov:skip=CKV_AWS_96:Ensure all data stored in Aurora is securely encrypted at rest
  #checkov:skip=CKV_AWS_128:Ensure that an Amazon RDS Clusters have AWS Identity and Access Management (IAM) authentication enabled
  #checkov:skip=CKV_AWS_162:Ensure RDS cluster has IAM authentication enabled
  #checkov:skip=CKV_AWS_118:Ensure that enhanced monitoring is enabled for Amazon RDS instances
  #checkov:skip=CKV2_AWS_8:Ensure that RDS clusters has backup plan of AWS Backup
  #checkov:skip=CKV_AWS_139:Ensure that RDS clusters have deletion protection enabled
  instance_count      = 1
  availability_zones  = data.aws_availability_zones.available.names
  engine              = "aurora-mysql"
  port                = 3306
  instance_class      = "db.r5.2xlarge"
  subnet_ids          = data.aws_subnets.database.ids
  cluster_identifier  = local.cluster_name
  master_username     = random_string.master_username.result
  master_password     = random_password.master_password.result
  vpc_id              = data.aws_vpc.supporting.id
  skip_final_snapshot = true
  tags                = local.tags
}
