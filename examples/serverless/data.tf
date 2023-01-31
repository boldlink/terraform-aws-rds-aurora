data "aws_partition" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "backup" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }  
  }
}

data "aws_vpc" "supporting" {
  filter {
    name   = "tag:Name"
    values = [local.supporting_resources_name]
  }
}


data "aws_subnets" "database" {
  filter {
    name   = "tag:Name"
    values = ["${local.supporting_resources_name}.databases.int.*"]
  }
}

data "aws_kms_key" "supporting" {
  key_id = "alias/${local.supporting_resources_name}-alias"
}
