variable "engine_version" {
  description = "(Optional) The database engine version. Updating this argument results in an outage. The actual engine version used is returned in the attribute engine_version_actual."
  type        = string
  default     = "5.7.mysql_aurora.2.11.4"
}
