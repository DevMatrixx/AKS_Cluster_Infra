resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.aks_clusters

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = lookup(each.value, "dns_prefix", each.value.name)
  kubernetes_version  = lookup(each.value, "kubernetes_version", null)
  sku_tier            = lookup(each.value, "sku_tier", "Free")
  tags                = lookup(each.value, "tags", null)

  dynamic "default_node_pool" {
    for_each = lookup(each.value, "default_node_pool", null) != null ? [each.value.default_node_pool] : []
    content {
      name                = default_node_pool.value.name
      node_count          = lookup(default_node_pool.value, "node_count", 1)
      vm_size             = default_node_pool.value.vm_size
      os_disk_size_gb     = lookup(default_node_pool.value, "os_disk_size_gb", null)
      vnet_subnet_id      = lookup(default_node_pool.value, "vnet_subnet_id", null)
      type                = lookup(default_node_pool.value, "type", "VirtualMachineScaleSets")
      enable_auto_scaling = lookup(default_node_pool.value, "enable_auto_scaling", false)
      min_count           = lookup(default_node_pool.value, "min_count", null)
      max_count           = lookup(default_node_pool.value, "max_count", null)
      tags                = lookup(default_node_pool.value, "tags", null)
      zones               = lookup(default_node_pool.value, "zones", null)
    }
  }

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "network_profile" {
    for_each = lookup(each.value, "network_profile", null) != null ? [each.value.network_profile] : []
    content {
      network_plugin    = network_profile.value.network_plugin
      network_policy    = lookup(network_profile.value, "network_policy", null)
      dns_service_ip    = lookup(network_profile.value, "dns_service_ip", null)
      service_cidr      = lookup(network_profile.value, "service_cidr", null)
      pod_cidr          = lookup(network_profile.value, "pod_cidr", null)
      load_balancer_sku = lookup(network_profile.value, "load_balancer_sku", "standard")
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = lookup(each.value, "ingress_application_gateway", null) != null ? [each.value.ingress_application_gateway] : []
    content {
      gateway_id   = lookup(ingress_application_gateway.value, "gateway_id", null)
      gateway_name = lookup(ingress_application_gateway.value, "gateway_name", null)
      subnet_id    = lookup(ingress_application_gateway.value, "subnet_id", null)
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = lookup(each.value, "azure_active_directory_role_based_access_control", null) != null ? [each.value.azure_active_directory_role_based_access_control] : []
    content {
      tenant_id              = lookup(azure_active_directory_role_based_access_control.value, "tenant_id", null)
      admin_group_object_ids = lookup(azure_active_directory_role_based_access_control.value, "admin_group_object_ids", null)
      azure_rbac_enabled     = lookup(azure_active_directory_role_based_access_control.value, "azure_rbac_enabled", true)
    }
  }
}
