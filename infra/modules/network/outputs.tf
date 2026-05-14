output "spoke_vnet_id" {
  value = data.azurerm_virtual_network.spoke.id
}

output "subnet_id_app" {
  value = azurerm_subnet.app.id
}

output "subnet_id_pe" {
  value = azurerm_subnet.pe.id
}
