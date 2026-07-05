resource "terraform_data" "revision_trigger" {
  input = var.container_app_deployment_token
}

# Add the AAD client secret to the Container App secrets list
resource "azapi_update_resource" "app_secret" {
  type        = "Microsoft.App/containerApps@2025-01-01"
  resource_id = var.container_app_id

  lifecycle {
    replace_triggered_by = [terraform_data.revision_trigger]
  }

  body = {
    properties = {
      configuration = {
        secrets = [
          {
            name  = "aad-client-secret"
            value = var.client_secret
          }
        ]
      }
    }
  }
}

# Configure EasyAuth via the authConfigs sub-resource (used by the Container Apps auth platform)
resource "azapi_resource" "auth_config" {
  type      = "Microsoft.App/containerApps/authConfigs@2025-01-01"
  name      = "current"
  parent_id = var.container_app_id

  depends_on = [azapi_update_resource.app_secret]

  lifecycle {
    replace_triggered_by = [terraform_data.revision_trigger]
  }

  body = {
    properties = {
      platform = {
        enabled = true
      }

      globalValidation = {
        unauthenticatedClientAction = "RedirectToLoginPage"
        excludedPaths               = ["/healthz"]
      }

      httpSettings = {
        forwardProxy = {
          convention = "Standard"
        }
      }

      identityProviders = {
        azureActiveDirectory = {
          enabled = true

          login = {}

          registration = {
            clientId                = var.client_id
            clientSecretSettingName = "aad-client-secret"
            openIdIssuer            = "https://login.microsoftonline.com/${var.tenant_id}/v2.0"
          }

          validation = {
            allowedAudiences = ["api://${var.client_id}"]
          }
        }
      }
    }
  }
}
