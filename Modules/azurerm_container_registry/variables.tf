variable "acr_registries" {
  description = "Map of Azure Container Registries to create with dynamic nested configuration blocks"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = string
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    zone_redundancy_enabled       = optional(bool, false)
    tags                          = optional(map(string))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    georeplications = optional(list(object({
      location                = string
      zone_redundancy_enabled = optional(bool)
      tags                    = optional(map(string))
    })))

    network_rule_set = optional(object({
      default_action = optional(string, "Allow")
      ip_rules = optional(list(object({
        ip_range = string
      })))
    }))

    retention_policy = optional(object({
      days    = optional(number, 7)
      enabled = optional(bool, true)
    }))
  }))
}
