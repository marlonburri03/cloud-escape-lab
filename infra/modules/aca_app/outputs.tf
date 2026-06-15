output "name" {
  value = azurerm_container_app.app.name
}

output "fqdn" {
  value = azurerm_container_app.app.ingress[0].fqdn
}

output "principal_id" {
  value = azurerm_container_app.app.identity[0].principal_id
}

output "app_name" {
  value = azurerm_container_app.app.name
}
