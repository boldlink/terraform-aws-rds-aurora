locals {
  supporting_resources_name = "terraform-aws-rds-aurora"
  dns_suffix                = data.aws_partition.current.dns_suffix
  vpc_cidr                  = data.aws_vpc.supporting.cidr_block
  tags                      = merge({ Name = var.cluster_identifier }, var.tags)
}
