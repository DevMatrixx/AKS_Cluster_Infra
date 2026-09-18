output "kubernetes_clusters" {
  description = "Outputs of all created Azure Kubernetes Service clusters"
  value       = azurerm_kubernetes_cluster.aks
}

output "aks_ids" {
  description = "Map of AKS cluster IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.id }
}

output "kube_config_raw" {
  description = "Map of raw kubeconfig outputs for clusters"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.kube_config_raw }
  sensitive   = true
}

output "principal_ids" {
  description = "Map of system-assigned identity principal IDs"
  value = {
    for k, v in azurerm_kubernetes_cluster.aks : k => (
      length(v.identity) > 0 ? v.identity[0].principal_id : null
    )
  }
}
