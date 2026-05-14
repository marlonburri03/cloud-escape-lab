# resource group inputs
variable "resource_group_name" {
  description = "Name of the workload resource group that hosts the ACR."
  type        = string
}

variable "location" {
  description = "Azure region for the ACR."
  type        = string
}

# acr

variable "name" {
  description = "ACR name (lowercase alphanumeric, 5-50 chars, must be globally unique)."
  type        = string
}

variable "sku" {
  description = "ACR sku. Basic for POC, Premium when private endpoints or geo-replication are needed."
  type        = string
}

variable "tags" {
  description = "Tags applied to the ACR."
  type        = map(string)
}
