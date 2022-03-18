
variable "master_password" {
  description = "(Required unless a snapshot_identifier or replication_source_identifier is provided or unless a global_cluster_identifier is provided when the cluster is the 'secondary' cluster of a global database) Password for the master DB user."
  type        = string
}

variable "master_username" {
  description = "(Required unless a snapshot_identifier or replication_source_identifier is provided or unless a global_cluster_identifier is provided when the cluster is the 'secondary' cluster of a global database) Username for the master DB user. "
  type        = string
}

variable "allow_major_version_upgrade" {
  description = "(Optional) Enable to allow major engine version upgrades when changing engine versions. Defaults to false."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "(Optional) Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is false"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "(Optional) A list of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply. It is recommended to specify 3 AZs or use the lifecycle configuration block ignore_changes argument if necessary."
  type        = list(string)
  default     = []
}

variable "backtrack_window" {
  description = "(Optional) The target backtrack window, in seconds. Only available for aurora and aurora-mysql engines currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours)"
  type        = number
  default     = 0
}

variable "backup_retention_period" {
  description = "(Optional) The days to retain backups for. Default 1"
  type        = number
  default     = 1
}

variable "cluster_identifier_prefix" {
  description = "(Optional, Forces new resource) Creates a unique cluster identifier beginning with the specified prefix. Conflicts with cluster_identifier."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "(Optional, Forces new resources) The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "(Optional, boolean) Copy all Cluster tags to snapshots. Default is false."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "(Optional) Name for an automatically created database on cluster creation."
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_name" {
  description = "(Optional) A cluster parameter group to associate with the cluster."
  type        = string
  default     = null
}

variable "db_instance_parameter_group_name" {
  description = "(Optional) Instance parameter group to associate with all instances of the DB cluster. The db_instance_parameter_group_name parameter is only valid in combination with the allow_major_version_upgrade parameter."
  type        = string
  default     = null
}

variable "db_subnet_group_name" {
  description = "(Optional) A DB subnet group to associate with this DB instance. NOTE: This must match the db_subnet_group_name specified on every aws_rds_cluster_instance in the cluster."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "(Optional) If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false."
  type        = bool
  default     = false
}

variable "enable_http_endpoint" {
  description = "(Optional) Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless."
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "(Optional) Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql (PostgreSQL)"
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "(Optional) The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql"
  type        = string
  default     = "aurora"
}

variable "engine_mode" {
  description = "(Optional) The database engine mode. Valid values: global (only valid for Aurora MySQL 1.21 and earlier), multimaster, parallelquery, provisioned, serverless. Defaults to: provisioned. "
  type        = string
  default     = "provisioned"
}

variable "engine_version" {
  description = "(Optional) The database engine version. Updating this argument results in an outage. The actual engine version used is returned in the attribute engine_version_actual."
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "(Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made."
  type        = string
  default     = null
}

variable "global_cluster_identifier" {
  description = "(Optional) The global cluster identifier specified on aws_rds_global_cluster."
  type        = string
  default     = null
}

variable "enable_global_write_forwarding" {
  description = "(Optional) Whether cluster should forward writes to an associated global cluster."
  type        = bool
  default     = false
}

variable "iam_database_authentication_enabled" {
  description = "(Optional) Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "(Optional) A List of ARNs for the IAM roles to associate to the RDS Cluster."
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "(Optional) The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
  type        = string
  default     = null
}

variable "port" {
  description = "(Optional) The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

variable "preferred_backup_window" {
  description = "(Optional) The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC. Default: A 30-minute window selected at random from an 8-hour block of time per region"
  type        = string
  default     = "04:00-09:00"
}

variable "preferred_maintenance_window" {
  description = "(Optional) The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30"
  type        = string
  default     = "wed:04:00-wed:04:30"
}

variable "replication_source_identifier" {
  description = "(Optional) ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica."
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "(Optional) Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted, using the value from final_snapshot_identifier. Default is false."
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "(Optional) Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot."
  type        = string
  default     = null
}

variable "source_region" {
  description = "(Optional) The source region for an encrypted replica DB cluster."
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "(Optional) Specifies whether the DB cluster is encrypted. The default is false for provisioned engine_mode and true for serverless engine_mode. When restoring an unencrypted snapshot_identifier, the kms_key_id argument must be provided to encrypt the restored cluster. "
  type        = bool
  default     = false
}

#Tags

variable "environment" {
  type        = string
  description = "The environment this resource is being deployed to"
  default     = null
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type        = map(string)
  default     = {}
}

#S3 import

variable "s3_import" {
  description = " Requires that the S3 bucket be in the same region as the RDS cluster you're trying to create."
  type = list(object({
    source_engine         = string
    source_engine_version = string
    bucket_name           = string
    bucket_prefix         = string
    ingestion_role        = string
  }))
  default = []
}
# Restore to point in time
variable "restore_to_point_in_time" {
  description = "(Optional) Nested attribute for point in time restore. "
  type = list(object({
    source_cluster_identifier  = string
    restore_type               = string
    use_latest_restorable_time = bool
  }))
  default = []
}

variable "timeouts" {
  description = "aws_rds_cluster provides the following Timeouts configuration options: create, update, delete"
  type = list(object({
    create = string
    update = string
    delete = string
  }))
  default = []
}

variable "scaling_configuration" {
  description = "(Optional) Nested attribute with scaling properties. Only valid when engine_mode is set to serverless"
  type = list(object({
    auto_pause               = bool
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = number
    timeout_action           = string
  }))
  default = []
}

# Security Group

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID"
  type        = string
  default     = null
}

variable "sg_name" {
  description = " (Optional, Forces new resource) Name of the security group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "create_security_group" {
  description = "Whether to create a Security Group for RDS cluster."
  default     = false
  type        = bool
}

variable "ingress_protocol" {
  description = "(Required) Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type        = string
  default     = "tcp"
}

variable "ingress_type" {
  description = " (Required) Type of rule being created. Valid options are ingress (inbound) or egress (outbound)"
  type        = string
  default     = "ingress"
}

variable "egress_protocol" {
  description = "(Required) Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type        = string
  default     = "-1"
}

variable "egress_type" {
  description = " (Required) Type of rule being created. Valid options are ingress (inbound) or egress (outbound)"
  type        = string
  default     = "egress"
}

variable "cidr_blocks" {
  description = "List of CIDR blocks"
  default     = "0.0.0.0/0"
  type        = string
}

variable "from_port" {
  description = "(Required) Start port (or ICMP type number if protocol is 'icmp' or 'icmpv6')"
  type        = number
  default     = 0
}

variable "to_port" {
  description = "(Required) End port (or ICMP code if protocol is 'icmp')"
  type        = number
  default     = 0
}
