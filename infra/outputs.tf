locals {
  frontend_ingress_fqdn = coalesce(
    module.aca_app_frontend.fqdn,
    "${module.aca_app_frontend.name}.${module.aca_env.default_domain}"
  )

  backend_ingress_fqdn = coalesce(
    module.aca_app_backend.fqdn,
    "${module.aca_app_backend.name}.internal.${module.aca_env.default_domain}"
  )
}

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
  description = "Default domain of the ACA environment. Configure this as the AppGW backend pool FQDN."
  value       = module.aca_env.default_domain
}

output "aca_env_static_ip_address" {
  description = "Private static IP of the ACA environment internal load balancer."
  value       = module.aca_env.static_ip_address
}

output "frontend_fqdn" {
  description = "Frontend Container App ingress FQDN. Use this as AppGW backend_host_name for frontend routes."
  value       = local.frontend_ingress_fqdn
}

output "backend_fqdn" {
  description = "Backend Container App ingress FQDN. Use this as AppGW backend_host_name for /tutorial-room* routes."
  value       = local.backend_ingress_fqdn
}

output "connectivity_appgw_config" {
  description = "Recommended connectivity values for AppGW host headers and path rules."
  value = {
    frontend_backend_host_name = local.frontend_ingress_fqdn
    backend_backend_host_name  = local.backend_ingress_fqdn
    backend_protocol           = "http"
    backend_port               = 80
    probe_path                 = "/healthz"
    backend_paths              = ["/tutorial-room", "/tutorial-room/*"]
  }
}

output "frontend_app_name" {
  value = module.aca_app_frontend.name
}

output "backend_app_name" {
  value = module.aca_app_backend.name
}
