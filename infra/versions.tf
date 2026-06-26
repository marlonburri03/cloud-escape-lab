terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = "00000000-0000-0000-0000-000000000003"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  use_oidc        = var.use_oidc
}

provider "azapi" {
  tenant_id = var.tenant_id
}
