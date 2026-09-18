resource "azurerm_container_registry" "acr" {
  for_each = var.acr_registries

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  sku                           = each.value.sku
  admin_enabled                 = lookup(each.value, "admin_enabled", false)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  zone_redundancy_enabled       = lookup(each.value, "zone_redundancy_enabled", false)
  tags                          = lookup(each.value, "tags", null)

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "georeplications" {
    for_each = lookup(each.value, "georeplications", null) != null ? each.value.georeplications : []
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = lookup(georeplications.value, "zone_redundancy_enabled", null)
      tags                    = lookup(georeplications.value, "tags", null)
    }
  }

  dynamic "network_rule_set" {
    for_each = lookup(each.value, "network_rule_set", null) != null ? [each.value.network_rule_set] : []
    content {
      default_action = lookup(network_rule_set.value, "default_action", "Allow")

      dynamic "ip_rule" {
        for_each = lookup(network_rule_set.value, "ip_rules", [])
        content {
          action   = "Allow"
          ip_range = ip_rule.value.ip_range
        }
      }
    }
  }

  dynamic "retention_policy" {
    for_each = lookup(each.value, "retention_policy", null) != null ? [each.value.retention_policy] : []
    content {
      days    = lookup(retention_policy.value, "days", 7)
      enabled = lookup(retention_policy.value, "enabled", true)
    }
  }
}
