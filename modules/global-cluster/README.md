# global-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_rds_global_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_global_cluster"></a> [create\_global\_cluster](#input\_create\_global\_cluster) | Whether you are creating a global cluster or not. | `bool` | `false` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | (Optional, Forces new resources) Name for an automatically created database on cluster creation. | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | (Optional) If the Global Cluster should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false. | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | (Optional, Forces new resources) Name of the database engine to be used for this DB cluster. Terraform will only perform drift detection if a configuration value is provided. Valid values: aurora, aurora-mysql, aurora-postgresql. Defaults to aurora. Conflicts with source\_db\_cluster\_identifier. | `string` | `"aurora"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | (Optional) Engine version of the Aurora global database. The engine, engine\_version, and instance\_class (on the aws\_rds\_cluster\_instance) must together support global databases. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (Optional) Enable to remove DB Cluster members from Global Cluster on destroy. Required with source\_db\_cluster\_identifier. | `bool` | `true` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | (Required, Forces new resources) Global cluster identifier. | `string` | `""` | no |
| <a name="input_source_db_cluster_identifier"></a> [source\_db\_cluster\_identifier](#input\_source\_db\_cluster\_identifier) | (Optional) Amazon Resource Name (ARN) to use as the primary DB Cluster of the Global Cluster on creation. | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | (Optional, Forces new resources) Specifies whether the DB cluster is encrypted. The default is false unless source\_db\_cluster\_identifier is specified and encrypted. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | RDS Global Cluster Amazon Resource Name (ARN) |
| <a name="output_global_cluster_members"></a> [global\_cluster\_members](#output\_global\_cluster\_members) | Set of objects containing Global Cluster members. |
| <a name="output_global_cluster_resource_id"></a> [global\_cluster\_resource\_id](#output\_global\_cluster\_resource\_id) | AWS Region-unique, immutable identifier for the global database cluster. This identifier is found in AWS CloudTrail log entries whenever the AWS KMS key for the DB cluster is accessed |
| <a name="output_id"></a> [id](#output\_id) | RDS Global Cluster identifier |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
