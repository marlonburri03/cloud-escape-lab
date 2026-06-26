resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_container" "this" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.this.id
}

resource "azurerm_role_assignment" "user_blob_contributor" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.user_object_id
  principal_type       = "User"
}
