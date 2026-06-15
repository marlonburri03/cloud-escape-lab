output "workload_resource_group_name" {
  value = azurerm_resource_group.workload.name
}

output "location" {
  value = azurerm_resource_group.workload.location
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "acr_name" {
  value = module.acr.name
}

output "aca_env_default_domain" {
  value = module.aca_env.default_domain
}

output "aca_env_static_ip_address" {
  value = module.aca_env.static_ip_address
}

output "frontend_fqdn" {
  value = module.aca_app_frontend.fqdn
}

output "backend_fqdn" {
  value = module.aca_app_backend.fqdn
}

output "backend_app_name" {
  value = module.aca_app_backend.app_name
}

output "frontend_app_name" {
  value = module.aca_app_frontend.app_name
}

# structured output consumed by Contoso AGW change request
output "connectivity_appgw_config" {
  value = {
    frontend_backend_host_name = module.aca_app_frontend.fqdn
    backend_backend_host_name  = module.aca_app_backend.fqdn
    backend_paths              = ["/tutorial-room", "/tutorial-room/*"]
    backend_port               = 80
    backend_protocol           = "http"
    probe_path                 = "/healthz"
  }
}
