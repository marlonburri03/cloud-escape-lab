resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_federated_identity_credential" "gitlab" {
  name                      = "${var.name}-fic"
  user_assigned_identity_id = azurerm_user_assigned_identity.this.id
  issuer                    = "https://gitlab.com"
  subject                   = "project_path:${var.gitlab_project_path}:environment:production"
  audience                  = ["https://gitlab.com"]
}

resource "azurerm_role_assignment" "storage_blob_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "subscription_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "subscription_uaa" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
