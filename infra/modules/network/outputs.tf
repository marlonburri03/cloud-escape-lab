output "spoke_vnet_id" {
  value = data.azurerm_virtual_network.spoke.id
}

output "subnet_id_aca" {
  value = azurerm_subnet.aca.id
}

output "subnet_id_pe" {
  value = azurerm_subnet.pe.id
}
