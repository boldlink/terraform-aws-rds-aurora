resource "aws_rds_cluster" "this" {
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  availability_zones                  = var.availability_zones
  backtrack_window                    = var.backtrack_window
  backup_retention_period             = var.backup_retention_period
  cluster_identifier_prefix           = var.cluster_identifier_prefix
  cluster_identifier                  = var.cluster_identifier
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  db_instance_parameter_group_name    = var.db_instance_parameter_group_name
  db_subnet_group_name                = var.db_subnet_group_name
  deletion_protection                 = var.deletion_protection
  enable_http_endpoint                = var.enable_http_endpoint
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  final_snapshot_identifier           = var.final_snapshot_identifier
  global_cluster_identifier           = var.global_cluster_identifier
  enable_global_write_forwarding      = var.enable_global_write_forwarding
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  iam_roles                           = var.iam_roles
  kms_key_id                          = var.kms_key_id
  master_password                     = var.master_password
  master_username                     = var.master_username
  port                                = var.port
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  replication_source_identifier       = var.replication_source_identifier
  skip_final_snapshot                 = var.skip_final_snapshot
  snapshot_identifier                 = var.snapshot_identifier
  source_region                       = var.source_region
  storage_encrypted                   = var.storage_encrypted
  tags = merge(
    {
      "Environment" = var.environment
    },
    var.other_tags,
  )
  vpc_security_group_ids = [join("", aws_security_group.this.*.id)]

  # This will not recreate the resource if the S3 object changes in some way. It's only used to initialize the database. This only works currently with the aurora engine.
  dynamic "s3_import" {
    for_each = var.s3_import
    content {
      bucket_name           = lookup(s3_import.value, "bucket_name", null)
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = lookup(s3_import.value, "ingestion_role", null)
      source_engine         = lookup(s3_import.value, "source_engine", null)
      source_engine_version = lookup(s3_import.value, "source_engine_version", null)
    }
  }

  # The DB cluster is created from the source DB cluster with the same configuration as the original DB cluster, except that the new DB cluster is created with the default DB security group. Thus, the following arguments should only be specified with the source DB cluster's respective values: database_name, master_username, storage_encrypted, replication_source_identifier, and source_region.
  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time
    content {
      source_cluster_identifier  = lookup(restore_to_point_in_time.value, "source_cluster_identifier", "example")
      restore_type               = lookup(restore_to_point_in_time.value, "source_cluster_identifier", "copy-on-write")
      use_latest_restorable_time = lookup(restore_to_point_in_time.value, "source_cluster_identifier", true)
    }

  }

  # scaling_configuration configuration is only valid when engine_mode is set to serverless.
  dynamic "scaling_configuration" {
    for_each = var.scaling_configuration
    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = lookup(timeouts.value, "create", "120m")
      update = lookup(timeouts.value, "update", "120m")
      delete = lookup(timeouts.value, "delete", "120m")
    }
  }
}

resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "RDS cluster Security Group"
  tags = merge(
    {
      "Environment" = var.environment
    },
    var.other_tags,
  )
}

resource "aws_security_group_rule" "ingress" {
  count                    = var.create_security_group ? 1 : 0
  type                     = var.ingress_type
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = var.ingress_protocol
  source_security_group_id = join("", aws_security_group.this.*.id)
  security_group_id        = join("", aws_security_group.this.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = var.create_security_group ? 1 : 0
  type              = var.egress_type
  description       = "Allow all egress traffic"
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.egress_protocol
  cidr_blocks       = [var.cidr_blocks]
  security_group_id = join("", aws_security_group.this.*.id)
}
