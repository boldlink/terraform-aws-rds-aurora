output "rds_cluster_output" {
  value = [
    module.rds_cluster,
  ]
  description = "Values for resources created by module."
}
