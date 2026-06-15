# create azure container registry
resource "azurerm_container_registry" "acr" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = false
  public_network_access_enabled = true

  lifecycle {
<<<<<<< HEAD
    ignore_changes = [tags]
=======
    ignore_changes = [
      tags
    ]
>>>>>>> 35b35a3 (S3M-25: format files)
  }
}
