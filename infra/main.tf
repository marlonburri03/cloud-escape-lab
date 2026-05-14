# create resource group for workload
resource "azurerm_resource_group" "workload" {
  name     = var.workload_resource_group_name
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

# call network module
module "network" {
  source                    = "./modules/network"
  spoke_vnet_resource_group = var.spoke_vnet_resource_group
  spoke_vnet_name           = var.spoke_vnet_name
  subnet_app_address_prefix = var.subnet_app_address_prefix
  subnet_pe_address_prefix  = var.subnet_pe_address_prefix
  tags                      = var.tags
}

# call azure container registry module
module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.workload.name
  location            = azurerm_resource_group.workload.location
  name                = var.acr_name
  sku                 = var.acr_sku
  tags                = var.tags
}

# call app service module
module "app_service" {
  source                    = "./modules/app_service"
  resource_group_name       = azurerm_resource_group.workload.name
  location                  = azurerm_resource_group.workload.location
  name_prefix               = var.name_prefix
  subnet_id_app_integration = module.network.subnet_id_app
  acr_id                    = module.acr.id
  acr_login_server          = module.acr.login_server
  image_name                = var.frontend_image_name
  image_tag                 = var.frontend_image_tag
  appgw_subnet_cidr         = var.appgw_subnet_cidr
  tags                      = var.tags
}
