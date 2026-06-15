output "name" {
  value = azurerm_container_app.app.name
}

output "fqdn" {
<<<<<<< HEAD
  description = "Ingress FQDN of the Container App (external: <app>.<domain>, internal: <app>.internal.<domain>)."
  value       = try(azurerm_container_app.app.ingress[0].fqdn, null)
}

output "principal_id" {
  description = "Principal ID of the system-assigned managed identity."
  value       = azurerm_container_app.app.identity[0].principal_id
=======
  value = azurerm_container_app.app.ingress[0].fqdn
}

output "principal_id" {
  value = azurerm_container_app.app.identity[0].principal_id
}

output "app_name" {
  value = azurerm_container_app.app.name
>>>>>>> 35b35a3 (S3M-25: format files)
}
