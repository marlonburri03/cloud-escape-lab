output "default_hostname" {
  value = azurerm_linux_web_app.frontend.default_hostname
}

output "name" {
  value = azurerm_linux_web_app.frontend.name
}

output "id" {
  value = azurerm_linux_web_app.frontend.id
}

output "principal_id" {
  value = azurerm_linux_web_app.frontend.identity[0].principal_id
}
