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

output "frontend_default_hostname" {
  value = module.app_service.default_hostname
}

output "frontend_app_name" {
  value = module.app_service.name
}
