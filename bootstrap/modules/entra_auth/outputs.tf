output "client_id" {
  value = azuread_application.app.client_id
}

output "client_secret" {
  value     = azuread_application_password.client_secret.value
  sensitive = true
}

output "service_principal_id" {
  value = azuread_service_principal.service_principal.id
}
