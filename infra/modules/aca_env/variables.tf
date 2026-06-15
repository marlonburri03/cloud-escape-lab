<<<<<<< HEAD
variable "resource_group_name" {
  description = "Resource group for the ACA environment and Log Analytics workspace."
=======
variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy the ACA environment into."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

<<<<<<< HEAD
variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "subnet_id_aca" {
  description = "ID of the subnet delegated to Microsoft.App/environments."
=======
variable "subnet_id" {
  description = "Subnet ID delegated to Microsoft.App/environments."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = string
}
