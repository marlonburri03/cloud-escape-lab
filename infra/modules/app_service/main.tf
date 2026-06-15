# create app service plan
resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.name_prefix}-frontend"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P0v3"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# create linux web app
resource "azurerm_linux_web_app" "frontend" {
  name                          = "app-${var.name_prefix}-frontend"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.plan.id
  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = var.subnet_id_app_integration

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                               = true
    ftps_state                              = "Disabled"
    http2_enabled                           = true
    minimum_tls_version                     = "1.2"
    container_registry_use_managed_identity = true
    health_check_path                       = "/healthz"
    vnet_route_all_enabled                  = true

    application_stack {
      docker_registry_url = "https://${var.acr_login_server}"
      docker_image_name   = "${var.image_name}:${var.image_tag}"
    }

    dynamic "ip_restriction" {
      for_each = var.appgw_subnet_cidr == null ? [] : [var.appgw_subnet_cidr]
      content {
        name       = "AllowAppGwSubnet"
        action     = "Allow"
        priority   = 100
        ip_address = ip_restriction.value
      }
    }

    dynamic "ip_restriction" {
      for_each = var.appgw_subnet_cidr == null ? [] : [1]
      content {
        name       = "DenyAll"
        action     = "Deny"
        priority   = 2147483647
        ip_address = "0.0.0.0/0"
      }
    }
  }

  app_settings = {
    WEBSITES_PORT    = "8000"
    DOCKER_ENABLE_CI = "true"
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    application_logs {
      file_system_level = "Information"
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# add role assignment for the web app to pull from azure container registry
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.frontend.identity[0].principal_id

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
