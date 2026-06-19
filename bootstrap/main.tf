# create resource group
resource "azurerm_resource_group" "rg_bootstrap" {
  name     = var.resource_group_name
  location = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

# create storage account for terraform state
resource "azurerm_storage_account" "st_tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_bootstrap.name
  location                 = azurerm_resource_group.rg_bootstrap.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [tags]
  }
}

# create blob container for terraform state
resource "azurerm_storage_container" "st_tfstate_container" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.st_tfstate.id
}

# create managed identity
resource "azurerm_user_assigned_identity" "mi_maker" {
  name                = var.managed_identity_name
  resource_group_name = azurerm_resource_group.rg_bootstrap.name
  location            = azurerm_resource_group.rg_bootstrap.location

  lifecycle {
    ignore_changes = [tags]
  }
}

# add federated credential to managed identity for GitLab OIDC (main branch / production environment)
resource "azurerm_federated_identity_credential" "mi_maker_fic" {
  name                      = "${var.managed_identity_name}-fic"
  user_assigned_identity_id = azurerm_user_assigned_identity.mi_maker.id
  issuer                    = "https://gitlab.com"
  subject                   = "project_path:${var.gitlab_project_path}:environment:production"
  audience                  = ["https://gitlab.com"]
}


# add federated credential to managed identity for GitLab OIDC (merge request environment)
resource "azurerm_federated_identity_credential" "mi_maker_fic_mr" {
  name                      = "${var.managed_identity_name}-fic-mr"
  user_assigned_identity_id = azurerm_user_assigned_identity.mi_maker.id
  issuer                    = "https://gitlab.com"
  subject                   = "project_path:${var.gitlab_project_path}:environment:merge-request"
  audience                  = ["https://gitlab.com"]
}

# grant managed identity access to read/write Terraform state in storage account
resource "azurerm_role_assignment" "mi_maker_storage_blob_contributor" {
  scope                = azurerm_storage_account.st_tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.mi_maker.principal_id
}

# grant managed identity Contributor on the subscription so it can deploy resources
resource "azurerm_role_assignment" "mi_maker_subscription_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mi_maker.principal_id
}

# grant managed identity User Access Administrator so it can manage RBAC assignments
resource "azurerm_role_assignment" "mi_maker_subscription_uaa" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.mi_maker.principal_id
}

# grant my user access to the tfstate storage account
resource "azurerm_role_assignment" "user_storage_blob_contributor" {
  scope                = azurerm_storage_account.st_tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.user_object_id
  principal_type       = "User"
}
