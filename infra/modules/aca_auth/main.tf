resource "azapi_update_resource" "auth" {
  type        = "Microsoft.App/containerApps@2025-01-01"
  resource_id = var.container_app_id

  body = {
    properties = {
      configuration = {
        secrets = [
          {
            name  = "aad-client-secret"
            value = var.client_secret
          }
        ]

        auth = {
          platform = {
            enabled = true
          }

          globalValidation = {
            unauthenticatedClientAction = "RedirectToLoginPage"
          }

          identityProviders = {
            azureActiveDirectory = {
              enabled = true

              registration = {
                clientId = var.client_id

                clientSecretSettingName = "aad-client-secret"

                openIdIssuer = "https://login.microsoftonline.com/${var.tenant_id}/v2.0"
              }

              validation = {
                allowedAudiences = ["api://${var.client_id}"]
              }
            }
          }
        }
      }
    }
  }
}
