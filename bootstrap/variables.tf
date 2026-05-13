variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to create for storing the Terraform state"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account to create for storing the Terraform state"
  type        = string
}

variable "container_name" {
  description = "Name of the blob container to create for storing the Terraform state"
  type        = string
}

variable "managed_identity_name" {
  description = "Name of the managed identity to create"
  type        = string
}

variable "user_object_id" {
  description = "Entra ID object ID of a user"
  type        = string
}
