variable "aks_clusters" {
  description = "Map of Azure Kubernetes Clusters to create with dynamic nested configuration blocks"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    dns_prefix          = optional(string)
    kubernetes_version  = optional(string)
    sku_tier            = optional(string, "Free")
    tags                = optional(map(string))

    default_node_pool = object({
      name                = string
      vm_size             = string
      node_count          = optional(number, 1)
      os_disk_size_gb     = optional(number)
      vnet_subnet_id      = optional(string)
      type                = optional(string, "VirtualMachineScaleSets")
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
      tags                = optional(map(string))
      zones               = optional(list(string))
    })

    identity = object({
      type         = string
      identity_ids = optional(list(string))
    })

    network_profile = optional(object({
      network_plugin    = string
      network_policy    = optional(string)
      dns_service_ip    = optional(string)
      service_cidr      = optional(string)
      pod_cidr          = optional(string)
      load_balancer_sku = optional(string, "standard")
    }))

    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_id    = optional(string)
    }))

    azure_active_directory_role_based_access_control = optional(object({
      tenant_id              = optional(string)
      admin_group_object_ids = optional(list(string))
      azure_rbac_enabled     = optional(bool, true)
    }))
  }))
}
