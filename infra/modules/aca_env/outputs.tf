output "id" {
  value = azurerm_container_app_environment.env.id
}

output "default_domain" {
  value = azurerm_container_app_environment.env.default_domain
}

output "static_ip_address" {
  value = azurerm_container_app_environment.env.static_ip_address
}

output "law_id" {
  value = azurerm_log_analytics_workspace.law.id
}
