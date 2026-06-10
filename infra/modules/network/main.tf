# reference the vended spoke vnet
data "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  resource_group_name = var.spoke_vnet_resource_group
}

# create ACA infrastructure subnet with delegation to Microsoft.App/environments
# service endpoint for ACR bypasses the UDR/Firewall for image pulls (Basic ACR, public access)
resource "azurerm_subnet" "aca" {
  name                 = "snet-aca"
  resource_group_name  = var.spoke_vnet_resource_group
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  address_prefixes     = [var.subnet_aca_address_prefix]
  service_endpoints    = ["Microsoft.ContainerRegistry"]

  delegation {
    name = "delegation-aca"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
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
