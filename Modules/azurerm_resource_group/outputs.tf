output "resource_groups" {
  description = "Outputs of all created resource groups"
  value       = azurerm_resource_group.rg
}

output "resource_group_names" {
  description = "Map of resource group names"
  value       = { for k, v in azurerm_resource_group.rg : k => v.name }
}

output "resource_group_ids" {
  description = "Map of resource group IDs"
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}
