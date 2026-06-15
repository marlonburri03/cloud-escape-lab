variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy the ACA environment into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID delegated to Microsoft.App/environments."
  type        = string
}
