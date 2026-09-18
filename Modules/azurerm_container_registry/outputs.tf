output "container_registries" {
  description = "Outputs of all created container registries"
  value       = azurerm_container_registry.acr
}

output "acr_ids" {
  description = "Map of container registry IDs"
  value       = { for k, v in azurerm_container_registry.acr : k => v.id }
}

output "login_servers" {
  description = "Map of ACR login servers"
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}
