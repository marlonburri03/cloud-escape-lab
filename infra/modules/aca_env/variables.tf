variable "resource_group_name" {
  description = "Resource group for the ACA environment and Log Analytics workspace."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "subnet_id_aca" {
  description = "ID of the subnet delegated to Microsoft.App/environments."
  type        = string
}
