variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = "example-aurora-mysql-cluster"
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
