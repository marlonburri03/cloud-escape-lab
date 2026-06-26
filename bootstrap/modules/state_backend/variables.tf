variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique storage account name for Terraform state."
  type        = string
}

variable "container_name" {
  description = "Blob container name for Terraform state."
  type        = string
}

variable "user_object_id" {
  description = "Entra ID object ID of the admin user — granted Storage Blob Data Contributor."
  type        = string
}
