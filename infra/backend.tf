terraform {
  backend "azurerm" {
    resource_group_name  = "rg-bootstrap-lab-prod-escape"
    storage_account_name = "sttfstatescape"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
