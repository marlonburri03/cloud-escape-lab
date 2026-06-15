<<<<<<< HEAD
resource "azurerm_container_app" "app" {
  name                         = "ca-${var.name_prefix}-${var.app_name}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
=======
# container app
resource "azurerm_container_app" "app" {
  name                         = "ca-${var.name_prefix}-${var.app_name}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.aca_env_id
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
>>>>>>> 35b35a3 (S3M-25: format files)

  identity {
    type = "SystemAssigned"
  }

<<<<<<< HEAD
  ingress {
    external_enabled = var.external_ingress
    target_port      = var.app_port
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

=======
>>>>>>> 35b35a3 (S3M-25: format files)
  registry {
    server   = var.acr_login_server
    identity = "System"
  }

<<<<<<< HEAD
  template {
    min_replicas = 1
=======
  ingress {
    external_enabled = true
    target_port      = var.target_port
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = var.min_replicas
>>>>>>> 35b35a3 (S3M-25: format files)
    max_replicas = var.max_replicas

    container {
      name   = var.app_name
      image  = "${var.acr_login_server}/${var.image_name}:${var.image_tag}"
      cpu    = 0.5
      memory = "1Gi"

      dynamic "env" {
<<<<<<< HEAD
        for_each = var.env_vars
=======
        for_each = var.app_settings

>>>>>>> 35b35a3 (S3M-25: format files)
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
<<<<<<< HEAD

  lifecycle {
    ignore_changes = [tags]
  }
}

=======
}

# allow the container app's system-assigned identity to pull images from ACR
>>>>>>> 35b35a3 (S3M-25: format files)
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.app.identity[0].principal_id
}
