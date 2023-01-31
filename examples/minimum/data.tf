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
