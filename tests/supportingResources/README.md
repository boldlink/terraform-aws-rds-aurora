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

# terraform-aws-ecs-cluster supporting resources

These stacks are to be used on the examples testing and where setup to minimum dependencies,
they are not in any way the recommended setup for a production grade implementation.


This stack builds:
* VPC with public and Private subnets

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.10.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora_vpc"></a> [aurora\_vpc](#module\_aurora\_vpc) | boldlink/vpc/aws | 3.0.4 |
| <a name="module_kms_key"></a> [kms\_key](#module\_kms\_key) | boldlink/kms/aws | n/a |

## Resources

No resources.

## Inputs

No inputs.

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

### Supporting resources:

The example stacks are used by BOLDLink developers to validate the modules by building an actual stack on AWS.

Some of the modules have dependencies on other modules (ex. Ec2 instance depends on the VPC) so we create them
first and use data sources on the examples to use the stacks.

Any supporting resources will be available on the `tests/supportingResources` and the lifecycle is managed by the `Makefile` targets.

### Makefile
The makefile contain in this repo is optimised for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done seperately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```

#### BOLDLink-SIG 2023
