output "entra_client_id" {
  description = "Client ID of the Entra ID app registration. Add to infra/secrets.auto.tfvars."
  value       = module.entra_auth.client_id
}

output "entra_client_secret" {
  description = "Client secret of the Entra ID app registration. Add to infra/secrets.auto.tfvars."
  value       = module.entra_auth.client_secret
  sensitive   = true
}
