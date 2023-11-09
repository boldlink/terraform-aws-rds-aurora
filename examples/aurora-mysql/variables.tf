variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = "example-aurora-mysql-cluster"
}

variable "engine_version" {
  description = "(Optional) The database engine version. Updating this argument results in an outage. The actual engine version used is returned in the attribute engine_version_actual."
  type        = string
  default     = "5.7.mysql_aurora.2.11.4"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    Department         = "operations"
    InstanceScheduler  = true
    Project            = "aws-rds"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}
