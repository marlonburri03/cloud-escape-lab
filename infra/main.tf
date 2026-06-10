# create resource group for workload
resource "azurerm_resource_group" "workload" {
  name     = var.workload_resource_group_name
  location = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

# call network module
module "network" {
  source                    = "./modules/network"
  spoke_vnet_resource_group = var.spoke_vnet_resource_group
  spoke_vnet_name           = var.spoke_vnet_name
  subnet_aca_address_prefix = var.subnet_aca_address_prefix
  subnet_pe_address_prefix  = var.subnet_pe_address_prefix
}

# call azure container registry module
module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.workload.name
  location            = azurerm_resource_group.workload.location
  name                = var.acr_name
  sku                 = var.acr_sku
}

# container app environment
module "aca_env" {
  source              = "./modules/aca_env"
  resource_group_name = azurerm_resource_group.workload.name
  location            = azurerm_resource_group.workload.location
  name_prefix         = var.name_prefix
  subnet_id_aca       = module.network.subnet_id_aca
}

# frontend container app
module "aca_app_frontend" {
  source                       = "./modules/aca_app"
  resource_group_name          = azurerm_resource_group.workload.name
  name_prefix                  = var.name_prefix
  app_name                     = "frontend"
  container_app_environment_id = module.aca_env.id
  acr_id                       = module.acr.id
  acr_login_server             = module.acr.login_server
  image_name                   = var.frontend_image_name
  image_tag                    = var.frontend_image_tag
  app_port                     = 8000
  external_ingress             = true
  max_replicas                 = 3
  env_vars = {
    # BACKEND_URL is the URL the frontend (server-side) uses to reach the backend.
    # Within the ACA environment, container apps are reachable via their app name.
    # For browser-side JS calls, configure AppGW path routing (/tutorial-room/*) and set this
    # to the public AppGW hostname once available.
    BACKEND_URL = var.backend_api_url
  }
}

# backend container app
module "aca_app_backend" {
  source                       = "./modules/aca_app"
  resource_group_name          = azurerm_resource_group.workload.name
  name_prefix                  = var.name_prefix
  app_name                     = "backend"
  container_app_environment_id = module.aca_env.id
  acr_id                       = module.acr.id
  acr_login_server             = module.acr.login_server
  image_name                   = var.backend_image_name
  image_tag                    = var.backend_image_tag
  app_port                     = 5001
  external_ingress             = false
  max_replicas                 = 1 # SQLite: single replica only
}

# private DNS zone for the ACA environment
resource "azurerm_private_dns_zone" "aca_env" {
  name                = module.aca_env.default_domain
  resource_group_name = azurerm_resource_group.workload.name

  lifecycle {
    ignore_changes = [tags]
  }
}

# wildcard A record covers all container app FQDNs within the environment
resource "azurerm_private_dns_a_record" "aca_wildcard" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.aca_env.name
  resource_group_name = azurerm_resource_group.workload.name
  ttl                 = 300
  records             = [module.aca_env.static_ip_address]
}

# apex A record covers the environment FQDN itself (AppGW health probes)
resource "azurerm_private_dns_a_record" "aca_apex" {
  name                = "@"
  zone_name           = azurerm_private_dns_zone.aca_env.name
  resource_group_name = azurerm_resource_group.workload.name
  ttl                 = 300
  records             = [module.aca_env.static_ip_address]
}

# link the DNS zone to the spoke VNet so workloads can resolve ACA FQDNs
resource "azurerm_private_dns_zone_virtual_network_link" "aca_env_spoke" {
  name                  = "vnetlink-cae-spoke"
  resource_group_name   = azurerm_resource_group.workload.name
  private_dns_zone_name = azurerm_private_dns_zone.aca_env.name
  virtual_network_id    = module.network.spoke_vnet_id
  registration_enabled  = false

  lifecycle {
    ignore_changes = [tags]
  }
}
