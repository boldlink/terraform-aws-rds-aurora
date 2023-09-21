# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- use aws backup module in examples
- Add aws backup resources in the module with create being optional
- fix: changes in place when rds security group is not created
- fix: CKV_TF_1: "Ensure Terraform module sources use a commit hash"
- fix: CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
- fix: CKV_AWS_354: "Ensure RDS Performance Insights are encrypted using KMS CMKs"
- fix: CKV_AWS_324: "Ensure that RDS Cluster log capture is enabled"
- fix: CKV_AWS_325: "Ensure that RDS Cluster audit logging is enabled for MySQL engine"
- fix: CKV_AWS_326: "Ensure that RDS Aurora Clusters have backtracking enabled"

## [1.1.0] - 2023-09-21
- feat: added manage_master_user_password and master_user_secret_kms_key_id arguments
- fix: CKV_AWS_313: "Ensure RDS cluster configured to copy tags to snapshots"
- fix: CKV_AWS_353: "Ensure that RDS instances have performance insights enabled"
- removed random_password resources in all examples.
- fix: set module security group to always create by default

## [1.0.5] - 2023-08-17
- fix: Updated vpc module version to resolve pre-commit alerts arising from derecated arguments
- fix: updated engine versions
- feat: added checkov exceptions in `checkov.yml` file

## [1.0.4] - 2023-02-01
- fix: CKV2_AWS_8: Ensure that RDS clusters has backup plan of AWS Backup
- fix: resource recreation caused by availability zones
- Add Backup plan for RDS cluster in Example
- Add supporting resources for module
- Add new github workflow files

## [1.0.3] - 2022-07-06
### Changes
- Added the `.github/workflow` folder (not supposed to run gitcommit)
- Added `CHANGELOG.md`
- Added `CODEOWNERS`
- Added `versions.tf`, which is important for pre-commit checks
- Added `Makefile` for examples automation
- Added `.gitignore` file

## [1.0.2] - 2022-04-22
### Changes
- fix: removed duplicate code.
- fix: extra spaces removed.
- feat: removed deprecated example
- feat: global cluster and serverless example.
- feat: Slight re-arrangment.
- feat: modified cluster names
- feat: global cluster as a sub module.this rds aurora PRthis rds aurora PRthis rds aurora PR

## [1.0.1] - 2022-04-12
### Changes
- fix: removed deprecated example
- fix: unwanted files clean-up
- feat: added subnet group, security group, cluster instance & mysql examples
- feat: module upgrade.
- feat: Documentation edit
- feat: multiple rules for security group

## [1.0.0] - 2022-03-17
### Changes
- feat: Initial commit

[Unreleased]: https://github.com/boldlink/terraform-aws-rds-aurora/compare/1.0.5...HEAD
[1.0.5]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.5
[1.0.4]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.4
[1.0.3]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.3
[1.0.2]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.2
[1.0.1]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.0
