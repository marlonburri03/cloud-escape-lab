# resource group and location
variable "resource_group_name" {
  description = "Workload resource group that hosts the app service plan and web app."
  type        = string
}

variable "location" {
  description = "Azure region for the app service plan and web app."
  type        = string
}

# naming
variable "name_prefix" {
  description = "Naming prefix used to build app service plan and web app names."
  type        = string
}

# network integration
variable "subnet_id_app_integration" {
  description = "Subnet id delegated to Microsoft.Web/serverFarms (used for outbound vnet integration)."
  type        = string
}

# container image
variable "acr_id" {
  description = "Resource id of the acr containing the frontend image."
  type        = string
}

variable "acr_login_server" {
  description = "Login server fqdn of the acr (e.g. myacr.azurecr.io)."
  type        = string
}

variable "image_name" {
  description = "Repository / image name inside acr (e.g. frontend)."
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy (set by the ci pipeline)."
  type        = string
}

# access restriction
variable "appgw_subnet_cidr" {
  description = "CIDR of the application gateway subnet in the hub. Set to null to skip access restriction."
  type        = string
}

# tags
variable "tags" {
  description = "Tags applied to the app service plan and web app."
  type        = map(string)
}
