# log analytics workspace for the aca environment
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.name_prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# internal azure container apps environment (vnet-integrated)
resource "azurerm_container_app_environment" "env" {
  name                           = "cae-${var.name_prefix}"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id
  infrastructure_subnet_id       = var.subnet_id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = false

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
