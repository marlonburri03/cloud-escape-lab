# vended spoke vnet references
variable "spoke_vnet_resource_group" {
  description = "Resource group that holds the vended spoke vnet."
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the vended spoke vnet."
  type        = string
}

# subnet plan inside the vended /24
variable "subnet_app_address_prefix" {
  description = "CIDR for the app service vnet integration subnet."
  type        = string
}

variable "subnet_pe_address_prefix" {
  description = "CIDR for the private endpoint subnet."
  type        = string
}

# tags
variable "tags" {
  description = "Tags applied to created subnets (kept for consistency; subnets do not take tags)."
  type        = map(string)
}
