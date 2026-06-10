output "id" {
  value = azurerm_container_app_environment.env.id
}

output "name" {
  value = azurerm_container_app_environment.env.name
}

output "default_domain" {
  description = "Default domain of the ACA environment (used as Private DNS zone name for AppGW resolution)."
  value       = azurerm_container_app_environment.env.default_domain
}

output "static_ip_address" {
  description = "Internal LB IP of the ACA environment (A record target for Private DNS zone)."
  value       = azurerm_container_app_environment.env.static_ip_address
}
