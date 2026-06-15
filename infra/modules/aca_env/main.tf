<<<<<<< HEAD
=======
# log analytics workspace for the aca environment
>>>>>>> 35b35a3 (S3M-25: format files)
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.name_prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  lifecycle {
<<<<<<< HEAD
    ignore_changes = [tags]
  }
}

=======
    ignore_changes = [
      tags
    ]
  }
}

# internal azure container apps environment (vnet-integrated)
>>>>>>> 35b35a3 (S3M-25: format files)
resource "azurerm_container_app_environment" "env" {
  name                           = "cae-${var.name_prefix}"
  resource_group_name            = var.resource_group_name
  location                       = var.location
<<<<<<< HEAD
  infrastructure_subnet_id       = var.subnet_id_aca
  internal_load_balancer_enabled = true
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id
=======
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id
  infrastructure_subnet_id       = var.subnet_id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = false
>>>>>>> 35b35a3 (S3M-25: format files)

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  lifecycle {
<<<<<<< HEAD
    ignore_changes = [tags]
=======
    ignore_changes = [
      tags
    ]
>>>>>>> 35b35a3 (S3M-25: format files)
  }
}
