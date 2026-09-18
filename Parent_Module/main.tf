module "resource_group" {
  source          = "../Modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

module "container_registry" {
  depends_on     = [module.resource_group]
  source         = "../Modules/azurerm_container_registry"
  acr_registries = var.acr_registries
}

module "kubernetes_cluster" {
  depends_on   = [module.resource_group]
  source       = "../Modules/azurerm_kubernetes_cluster"
  aks_clusters = var.aks_clusters
}

# Optional: AcrPull Role Assignment granting AKS principal access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  for_each = {
    for pair in flatten([
      for aks_key, aks_val in module.kubernetes_cluster.kubernetes_clusters : [
        for acr_key, acr_val in module.container_registry.container_registries : {
          key          = "${aks_key}-${acr_key}"
          principal_id = aks_val.identity[0].principal_id
          acr_id       = acr_val.id
        } if length(aks_val.identity) > 0 && aks_val.identity[0].principal_id != null
      ]
    ]) : pair.key => pair
  }

  scope                            = each.value.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = each.value.principal_id
  skip_service_principal_aad_check = true
}
