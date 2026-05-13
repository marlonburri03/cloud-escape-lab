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

# add federated credential to managed identity for GitLab OIDC
resource "azurerm_federated_identity_credential" "mi_maker_fic" {
  name      = "${var.managed_identity_name}-fic"
  user_assigned_identity_id = azurerm_user_assigned_identity.mi_maker.id
  issuer    = "https://gitlab.com"
  subject   = "project_path:<your-gitlab-group>/cloud-escape-lab:ref_type:branch:ref:main"
  audience  = ["https://gitlab.com"]
}

# grant managed identity access to read/write Terraform state in storage account
resource "azurerm_role_assignment" "mi_maker_storage_blob_contributor" {
  scope                = azurerm_storage_account.st_tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.mi_maker.principal_id
}
