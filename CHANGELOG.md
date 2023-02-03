# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- use aws backup module in examples
- Add aws backup resources in the module with create being optional

## [1.0.4] - 2023-02-01
- fix: CKV2_AWS_8: Ensure that RDS clusters has backup plan of AWS Backup
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
- feat: global cluster as a sub module.

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

[Unreleased]: https://github.com/boldlink/terraform-aws-rds-aurora/compare/1.0.4...HEAD
[1.0.4]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.4
[1.0.3]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.3
[1.0.2]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.2
[1.0.1]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-rds-aurora/releases/tag/1.0.0
