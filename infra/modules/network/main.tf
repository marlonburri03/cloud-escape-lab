# reference the vended spoke vnet
data "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  resource_group_name = var.spoke_vnet_resource_group
}

# create app service integration subnet with delegation to Microsoft.Web/serverFarms
resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = var.spoke_vnet_resource_group
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  address_prefixes     = [var.subnet_app_address_prefix]

  delegation {
    name = "delegation-webserverfarms"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# create private endpoint subnet (no delegation)
resource "azurerm_subnet" "pe" {
  name                              = "snet-pe"
  resource_group_name               = var.spoke_vnet_resource_group
  virtual_network_name              = data.azurerm_virtual_network.spoke.name
  address_prefixes                  = [var.subnet_pe_address_prefix]
  private_endpoint_network_policies = "Disabled"
}
