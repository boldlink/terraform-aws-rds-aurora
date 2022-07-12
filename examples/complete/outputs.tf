output "aurora_global_cluster" {
  value = [
    module.primary_cluster,
    module.global_cluster
  ]
  description = "Values for resources created by module."
}
