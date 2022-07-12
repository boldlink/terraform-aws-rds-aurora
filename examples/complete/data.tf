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

###secondary region
data "aws_availability_zones" "secondary" {
  state    = "available"
  provider = aws.secondary
}

data "aws_region" "secondary" {
  provider = aws.secondary
}
