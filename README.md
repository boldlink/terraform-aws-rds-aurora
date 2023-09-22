[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-rds-aurora.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-rds-aurora/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-rds-aurora/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# AWS RDS Aurora Terraform module

## Description
This Terraform module Manages a RDS Aurora Cluster and its associated resources.

### Why choose this module
- Default configurations have been validated by Checkov to ensure best practices and security.
- Ability to create a global cluster, rds cluster, rds instance, security groups, auto-scaling configuration and parameter groups with minimum configuration changes
- Has elaborate examples that you can use to setup your cluster and instances within a very short time.

Examples available [here](https://github.com/boldlink/terraform-aws-rds-aurora/tree/main/examples)

## Usage
*NOTE*: These examples use the latest version of this module
```console
resource "random_string" "master_username" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

module "minimum" {
  source = "boldlink/rds-aurora/aws"
  instance_count      = 1
  availability_zones  = data.aws_availability_zones.available.names
  engine              = "aurora-mysql"
  port                = 3306
  instance_class      = "db.r5.2xlarge"
  subnet_ids          = data.aws_subnets.database.ids
  cluster_identifier  = local.cluster_name
  master_username     = random_string.master_username.result
  vpc_id              = data.aws_vpc.supporting.id
  skip_final_snapshot = true
  tags                = local.tags
}
```


## Documentation

[AWS RDS Aurora Documentation ](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.html)

[Terraform RDS Cluster Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.replicas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_endpoint) | resource |
| [aws_rds_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | (Optional) Enable to allow major engine version upgrades when changing engine versions. Defaults to false. | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | (Optional) Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is `false`. | `bool` | `false` | no |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | (Required) Policy that grants an entity permission to assume the role. | `string` | `""` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | (Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default true. | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | (Optional, Computed, Forces new resource) The EC2 Availability Zone that the DB instance is created in. | `string` | `null` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (Optional) A list of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply. It is recommended to specify 3 AZs or use the lifecycle configuration block ignore\_changes argument if necessary. | `list(string)` | `[]` | no |
| <a name="input_backtrack_window"></a> [backtrack\_window](#input\_backtrack\_window) | (Optional) The target backtrack window, in seconds. Only available for aurora and aurora-mysql engines currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours) | `number` | `0` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | (Optional) The days to retain backups for. Default 1 | `number` | `1` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | (Optional) The identifier of the CA certificate for the DB instance. | `string` | `null` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | (Optional, Forces new resources) The cluster identifier. If omitted, Terraform will assign a random, unique identifier. | `string` | `null` | no |
| <a name="input_cluster_identifier_prefix"></a> [cluster\_identifier\_prefix](#input\_cluster\_identifier\_prefix) | (Optional, Forces new resource) Creates a unique cluster identifier beginning with the specified prefix. Conflicts with cluster\_identifier. | `string` | `null` | no |
| <a name="input_cluster_parameters"></a> [cluster\_parameters](#input\_cluster\_parameters) | (Optional) A list of DB parameters to apply. Note that parameters may differ from a family to an other. | <pre>list(object({<br>    name         = string<br>    value        = string<br>    apply_method = string<br>  }))</pre> | `[]` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | (Optional, boolean) Copy all Cluster tags to snapshots. Default is `false`. | `bool` | `true` | no |
| <a name="input_create_cluster_endpoint"></a> [create\_cluster\_endpoint](#input\_create\_cluster\_endpoint) | Whether to create a cluster endpoint or not | `bool` | `false` | no |
| <a name="input_create_cluster_parameter_group"></a> [create\_cluster\_parameter\_group](#input\_create\_cluster\_parameter\_group) | Whether to create a cluster\_parameter\_group or not | `bool` | `false` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Whether to create the Subnet Group or not | `bool` | `true` | no |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Whether to create monitoring role or not | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a Security Group for RDS cluster. | `bool` | `true` | no |
| <a name="input_custom_endpoint_type"></a> [custom\_endpoint\_type](#input\_custom\_endpoint\_type) | (Required) The type of the endpoint. One of: READER , ANY . | `string` | `"READER"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | (Optional) Name for an automatically created database on cluster creation. | `string` | `null` | no |
| <a name="input_db_cluster_parameter_group_name"></a> [db\_cluster\_parameter\_group\_name](#input\_db\_cluster\_parameter\_group\_name) | (Optional) A cluster parameter group to associate with the cluster. | `string` | `null` | no |
| <a name="input_db_instance_parameter_group_name"></a> [db\_instance\_parameter\_group\_name](#input\_db\_instance\_parameter\_group\_name) | (Optional) Instance parameter group to associate with all instances of the DB cluster. The db\_instance\_parameter\_group\_name parameter is only valid in combination with the allow\_major\_version\_upgrade parameter. | `string` | `null` | no |
| <a name="input_db_parameter_group_name"></a> [db\_parameter\_group\_name](#input\_db\_parameter\_group\_name) | (Optional) The name of the DB parameter group to associate with this instance. | `string` | `""` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | (Optional) A DB subnet group to associate with this DB instance. NOTE: This must match the db\_subnet\_group\_name specified on every aws\_rds\_cluster\_instance in the cluster. | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | (Optional) If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the DB cluster parameter group. Defaults to `Managed by Terraform`. | `string` | `"Managed by Terraform."` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | (Optional) Egress rules to add to the security group | `any` | `{}` | no |
| <a name="input_enable_autoscaling"></a> [enable\_autoscaling](#input\_enable\_autoscaling) | Whether to enable autoscaling or not | `bool` | `false` | no |
| <a name="input_enable_global_write_forwarding"></a> [enable\_global\_write\_forwarding](#input\_enable\_global\_write\_forwarding) | (Optional) Whether cluster should forward writes to an associated global cluster. | `bool` | `false` | no |
| <a name="input_enable_http_endpoint"></a> [enable\_http\_endpoint](#input\_enable\_http\_endpoint) | (Optional) Enable HTTP endpoint (data API). Only valid when engine\_mode is set to serverless. | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | (Optional) Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql (PostgreSQL) | `list(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | (Required) The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql | `string` | n/a | yes |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | (Optional) The database engine mode. Valid values: global (only valid for Aurora MySQL 1.21 and earlier), multimaster, parallelquery, provisioned, serverless. Defaults to: provisioned. | `string` | `null` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | (Optional) The database engine version. Updating this argument results in an outage. The actual engine version used is returned in the attribute engine\_version\_actual. | `string` | `null` | no |
| <a name="input_family"></a> [family](#input\_family) | (Required) The family of the DB cluster parameter group. | `string` | `""` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | (Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made. | `string` | `null` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | (Optional) The global cluster identifier specified on `aws_rds_global_cluster`. | `string` | `null` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | (Optional) Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | `bool` | `false` | no |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | (Optional) A List of ARNs for the IAM roles to associate to the RDS Cluster. | `list(string)` | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | (Optional) Ingress rules to add to the security group | `any` | `{}` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | (Required) The instance class to use. For details on CPU and memory, see Scaling Aurora DB Instances. Aurora uses db.* instance classes/types. | `string` | `""` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of DocumentDB cluster instances to be created. | `number` | `2` | no |
| <a name="input_instance_timeouts"></a> [instance\_timeouts](#input\_instance\_timeouts) | aws\_rds\_cluster\_instance provides the following Timeouts configuration options: create, update, delete | <pre>list(object({<br>    create = string<br>    update = string<br>    delete = string<br>  }))</pre> | `[]` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Optional) The ARN for the KMS encryption key. When specifying kms\_key\_id, storage\_encrypted needs to be set to true. | `string` | `null` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | (Optional) Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if master\_password is provided. | `bool` | `true` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | (Required unless a snapshot\_identifier or replication\_source\_identifier is provided or unless a global\_cluster\_identifier is provided when the cluster is the 'secondary' cluster of a global database) Password for the master DB user. | `string` | `null` | no |
| <a name="input_master_user_secret_kms_key_id"></a> [master\_user\_secret\_kms\_key\_id](#input\_master\_user\_secret\_kms\_key\_id) | (Optional) Amazon Web Services KMS key identifier is the key ARN, key ID, alias ARN, or alias name for the KMS key. To use a KMS key in a different Amazon Web Services account, specify the key ARN or alias ARN. If not specified, the default KMS key for your Amazon Web Services account is used. | `string` | `null` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | (Required unless a snapshot\_identifier or replication\_source\_identifier is provided or unless a global\_cluster\_identifier is provided when the cluster is the 'secondary' cluster of a global database) Username for the master DB user. | `string` | `null` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum number of replicas | `number` | `1` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum number of replicas | `number` | `1` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | (Optional) The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60. | `number` | `0` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | (Optional) The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name. | `string` | `null` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | (Optional) Specifies whether Performance Insights is enabled or not. | `bool` | `false` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | (Optional) ARN for the KMS key to encrypt Performance Insights data. When specifying performance\_insights\_kms\_key\_id, performance\_insights\_enabled needs to be set to true. | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | (Optional) Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). When specifying performance\_insights\_retention\_period, performance\_insights\_enabled needs to be set to true. Defaults to '7'. | `number` | `7` | no |
| <a name="input_policy_arn"></a> [policy\_arn](#input\_policy\_arn) | (Required) - The ARN of the policy you want to apply | `string` | `""` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | Optional) The policy type. Valid values are StepScaling and TargetTrackingScaling. Defaults to StepScaling. | `string` | `"StepScaling"` | no |
| <a name="input_port"></a> [port](#input\_port) | (Optional) The port on which the DB accepts connections | `number` | `null` | no |
| <a name="input_predefined_metric_type"></a> [predefined\_metric\_type](#input\_predefined\_metric\_type) | The type of metric to scale on | `string` | `""` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | (Optional) The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC. Default: A 30-minute window selected at random from an 8-hour block of time per region | `string` | `"00:00-01:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | (Optional) The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30 | `string` | `"Sun:02:00-Sun:04:00"` | no |
| <a name="input_primary_cluster"></a> [primary\_cluster](#input\_primary\_cluster) | Confirms if this will be a primary cluster: If not, `database_name`, `master_username` and `master_password` are not required for `secondary` clusters with a `global_cluster_identifier` defined. | `bool` | `true` | no |
| <a name="input_promotion_tier"></a> [promotion\_tier](#input\_promotion\_tier) | (Optional) Default 0. Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoted to writer. | `number` | `0` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | (Optional) Bool to control if instance is publicly accessible. Default false. | `bool` | `false` | no |
| <a name="input_replication_source_identifier"></a> [replication\_source\_identifier](#input\_replication\_source\_identifier) | (Optional) ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica. | `string` | `null` | no |
| <a name="input_restore_to_point_in_time"></a> [restore\_to\_point\_in\_time](#input\_restore\_to\_point\_in\_time) | (Optional) Nested attribute for point in time restore. | <pre>list(object({<br>    source_cluster_identifier  = string<br>    restore_type               = string<br>    use_latest_restorable_time = bool<br>  }))</pre> | `[]` | no |
| <a name="input_s3_import"></a> [s3\_import](#input\_s3\_import) | Requires that the S3 bucket be in the same region as the RDS cluster you're trying to create. | `map(string)` | `null` | no |
| <a name="input_scalable_dimension"></a> [scalable\_dimension](#input\_scalable\_dimension) | (Required) The scalable dimension of the scalable target. | `string` | `""` | no |
| <a name="input_scale_in_cooldown"></a> [scale\_in\_cooldown](#input\_scale\_in\_cooldown) | (Optional) The amount of time, in seconds, after a scale in activity completes before another scale in activity can start. | `number` | `300` | no |
| <a name="input_scale_out_cooldown"></a> [scale\_out\_cooldown](#input\_scale\_out\_cooldown) | (Optional) The amount of time, in seconds, after a scale out activity completes before another scale out activity can start. | `number` | `300` | no |
| <a name="input_scaling_configuration"></a> [scaling\_configuration](#input\_scaling\_configuration) | (Optional) Nested attribute with scaling properties. Only valid when engine\_mode is set to serverless | `map(string)` | `{}` | no |
| <a name="input_service_namespace"></a> [service\_namespace](#input\_service\_namespace) | (Required) The AWS service namespace of the scalable target. | `string` | `"rds"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | (Optional) Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted, using the value from final\_snapshot\_identifier. Default is false. | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | (Optional) Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot. | `string` | `null` | no |
| <a name="input_source_region"></a> [source\_region](#input\_source\_region) | (Optional) The source region for an encrypted replica DB cluster. | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | (Optional) Specifies whether the DB cluster is encrypted. The default is false for provisioned engine\_mode and true for serverless engine\_mode. When restoring an unencrypted snapshot\_identifier, the kms\_key\_id argument must be provided to encrypt the restored cluster. | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Required) A list of VPC subnet IDs. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional)A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_target_value"></a> [target\_value](#input\_target\_value) | (Required) The target value for the metric. | `number` | `75` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | aws\_rds\_cluster provides the following Timeouts configuration options: create, update, delete | <pre>list(object({<br>    create = string<br>    update = string<br>    delete = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of cluster |
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | The availability zone of the instance |
| <a name="output_backup_retention_period"></a> [backup\_retention\_period](#output\_backup\_retention\_period) | The backup retention period |
| <a name="output_cluster_identifier"></a> [cluster\_identifier](#output\_cluster\_identifier) | The RDS Cluster Identifier |
| <a name="output_cluster_resource_id"></a> [cluster\_resource\_id](#output\_cluster\_resource\_id) | The RDS Cluster Resource ID |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The database name |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The DNS address of the RDS instance |
| <a name="output_engine"></a> [engine](#output\_engine) | The database engine |
| <a name="output_engine_version_actual"></a> [engine\_version\_actual](#output\_engine\_version\_actual) | The running version of the database. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Route53 Hosted Zone ID of the endpoint |
| <a name="output_id"></a> [id](#output\_id) | The RDS Cluster Identifier |
| <a name="output_master_username"></a> [master\_username](#output\_master\_username) | The master username for the database |
| <a name="output_port"></a> [port](#output\_port) | The database port |
| <a name="output_preferred_backup_window"></a> [preferred\_backup\_window](#output\_preferred\_backup\_window) | The daily time range during which the backups happen |
| <a name="output_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#output\_preferred\_maintenance\_window) | The maintenance window |
| <a name="output_reader_endpoint"></a> [reader\_endpoint](#output\_reader\_endpoint) | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |
| <a name="output_replication_source_identifier"></a> [replication\_source\_identifier](#output\_replication\_source\_identifier) | ARN of the source DB cluster or DB instance if this DB cluster is created as a Read Replica. |
| <a name="output_storage_encrypted"></a> [storage\_encrypted](#output\_storage\_encrypted) | Specifies whether the DB cluster is encrypted |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

### Supporting resources:

The example stacks are used by BOLDLink developers to validate the modules by building an actual stack on AWS.

Some of the modules have dependencies on other modules (ex. Ec2 instance depends on the VPC module) so we create them
first and use data sources on the examples to use the stacks.

Any supporting resources will be available on the `tests/supportingResources` and the lifecycle is managed by the `Makefile` targets.

Resources on the `tests/supportingResources` folder are not intended for demo or actual implementation purposes, and can be used for reference.

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done separately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```
* !!!DANGER!!! Clean the state files from examples and test/supportingResources - use with CAUTION!!!
```console
make cleanstatefiles
```


#### BOLDLink-SIG 2023
