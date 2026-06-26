output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}
