variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "engine" {
  description = "(Required) The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "(Optional) The database engine version. Updating this argument results in an outage. The actual engine version used is returned in the attribute engine_version_actual."
  type        = string
  default     = "5.7.mysql_aurora.2.11.3"
}

variable "ca_cert_identifier" {
  description = "(Optional) The identifier of the CA certificate for the DB instance."
  type        = string
  default     = "rds-ca-rsa2048-g1"
}

variable "tags" {
  description = "(Optional)A map of tags to assign to the resources"
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
