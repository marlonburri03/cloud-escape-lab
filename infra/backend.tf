terraform {
  backend "azurerm" {
    client_id            = "00000000-0000-0000-0000-000000000003"
    tenant_id            = "00000000-0000-0000-0000-000000000001"
    subscription_id      = "00000000-0000-0000-0000-000000000002"
    resource_group_name  = "rg-bootstrap-lab-prod-escape"
    storage_account_name = "sttfstatescape"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
