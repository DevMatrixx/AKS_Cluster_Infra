output "resource_group_ids" {
  description = "IDs of the created resource groups"
  value       = module.resource_group.resource_group_ids
}

output "acr_login_servers" {
  description = "Login servers for created Azure Container Registries"
  value       = module.container_registry.login_servers
}

output "aks_cluster_names" {
  description = "Names of the created Azure Kubernetes Service clusters"
  value       = { for k, v in module.kubernetes_cluster.kubernetes_clusters : k => v.name }
}

output "aks_kube_config_raw" {
  description = "Raw kubeconfig outputs for the created Kubernetes clusters"
  value       = module.kubernetes_cluster.kube_config_raw
  sensitive   = true
}
