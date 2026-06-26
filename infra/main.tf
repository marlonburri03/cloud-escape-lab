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

# call aca environment module
module "aca_env" {
  source              = "./modules/aca_env"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.workload.name
  location            = azurerm_resource_group.workload.location
  subnet_id           = module.network.subnet_id_aca
}

# frontend container app
module "aca_app_frontend" {
  source              = "./modules/aca_app"
  name_prefix         = var.name_prefix
  app_name            = "frontend"
  resource_group_name = azurerm_resource_group.workload.name
  aca_env_id          = module.aca_env.id
  acr_id              = module.acr.id
  acr_login_server    = module.acr.login_server
  image_name          = var.frontend_image_name
  image_tag           = var.frontend_image_tag
  target_port         = 8000
  min_replicas        = 1
  max_replicas        = 3
  app_settings = {
    BACKEND_URL = var.backend_api_url
  }
}

# entra auth module for frontend
module "aca_auth_frontend" {
  source = "./modules/aca_auth"

  container_app_id = module.aca_app_frontend.id

  tenant_id = var.tenant_id

  client_id     = var.entra_client_id
  client_secret = var.entra_client_secret
}

# backend container app
module "aca_app_backend" {
  source              = "./modules/aca_app"
  name_prefix         = var.name_prefix
  app_name            = "backend"
  resource_group_name = azurerm_resource_group.workload.name
  aca_env_id          = module.aca_env.id
  acr_id              = module.acr.id
  acr_login_server    = module.acr.login_server
  image_name          = var.backend_image_name
  image_tag           = var.backend_image_tag
  target_port         = 5001
  min_replicas        = 1
  max_replicas        = 1
}

# private dns zone for the aca environment (auto-named by azure)
resource "azurerm_private_dns_zone" "aca_env" {
  name                = module.aca_env.default_domain
  resource_group_name = azurerm_resource_group.workload.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_a_record" "aca_apex" {
  name                = "@"
  zone_name           = azurerm_private_dns_zone.aca_env.name
  resource_group_name = azurerm_resource_group.workload.name
  ttl                 = 300
  records             = [module.aca_env.static_ip_address]
}

resource "azurerm_private_dns_a_record" "aca_wildcard" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.aca_env.name
  resource_group_name = azurerm_resource_group.workload.name
  ttl                 = 300
  records             = [module.aca_env.static_ip_address]
}

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
