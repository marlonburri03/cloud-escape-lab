# values live in terraform.tfvars

# azure auth
variable "tenant_id" {
  description = "Entra ID tenant ID."
  type        = string
}

variable "subscription_id" {
  description = "Spoke subscription ID (sub-lab-prod-escape)."
  type        = string
}

variable "use_oidc" {
  description = "Use OIDC for authenticating the azurerm provider (true in CI, false locally)."
  type        = bool
}

# naming and region
variable "location" {
  description = "Primary Azure region for the spoke workload."
  type        = string
}

variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

# pre-existing network references
variable "spoke_vnet_resource_group" {
  description = "Resource group that holds the vended spoke VNet."
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the vended spoke VNet."
  type        = string
}

variable "hub_firewall_private_ip" {
  description = "Private IP of the central Azure Firewall in the hub."
  type        = string
}

# subnets inside the vended spoke vnet
variable "subnet_app_address_prefix" {
  description = "CIDR for the app service vnet integration subnet inside the vended spoke."
  type        = string
}

variable "subnet_pe_address_prefix" {
  description = "CIDR for the private endpoint subnet inside the vended spoke."
  type        = string
}

# workload resource group
variable "workload_resource_group_name" {
  description = "Resource group for Escape Room workload resources."
  type        = string
}

# hub references
variable "appgw_subnet_cidr" {
  description = "CIDR of the Application Gateway subnet in the hub. Used for App Service Access Restriction."
  type        = string
}

# azure container registry

variable "acr_name" {
  description = "Globally unique ACR name (lowercase alphanumeric, 5-50 chars)."
  type        = string
}

variable "acr_sku" {
  description = "ACR sku (Basic, Standard, or Premium). Premium only when private endpoints or geo-replication are required."
  type        = string
}

# frontend image
variable "frontend_image_name" {
  description = "Repository name for the frontend image inside ACR."
  type        = string
}

variable "frontend_image_tag" {
  description = "Frontend image tag to deploy. Overridden by CI ($CI_COMMIT_SHA)."
  type        = string
}

# backend image
variable "backend_image_name" {
  description = "Repository name for the backend API image inside ACR."
  type        = string
}

variable "backend_image_tag" {
  description = "Backend image tag to deploy. Overridden by CI ($CI_COMMIT_SHA)."
  type        = string
}
