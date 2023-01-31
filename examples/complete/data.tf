data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

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

###secondary region
data "aws_availability_zones" "secondary" {
  state    = "available"
  provider = aws.secondary
}

data "aws_region" "secondary" {
  provider = aws.secondary
}

data "aws_iam_policy_document" "backup" {
  statement {
    actions = ["sts:AssumeRole"]
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
