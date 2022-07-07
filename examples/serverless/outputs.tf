output "rds_serverless_output" {
  value = [
    module.aurora_serverless,
  ]
  description = "Values for resources created by module."
}
