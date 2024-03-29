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

# Terraform module usage example for aurora-mysql and how to restore to a point in time

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.10.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.24.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_cluster"></a> [rds\_cluster](#module\_rds\_cluster) | ../../ | n/a |
| <a name="module_restored_cluster"></a> [restored\_cluster](#module\_restored\_cluster) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_iam_role.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_string.master_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_subnets.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The cluster identifier. If omitted, Terraform will assign a random, unique identifier. | `string` | `"example-aurora-mysql-cluster"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | (Optional) The database engine version. Updating this argument results in an outage. The actual engine version used is returned in the attribute engine\_version\_actual. | `string` | `"5.7.mysql_aurora.2.11.4"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | <pre>{<br>  "Department": "operations",<br>  "Environment": "example",<br>  "InstanceScheduler": true,<br>  "LayerId": "cExample",<br>  "LayerName": "cExample",<br>  "Owner": "Boldlink",<br>  "Project": "aws-rds",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

No outputs.
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

#### BOLDLink-SIG 2023
