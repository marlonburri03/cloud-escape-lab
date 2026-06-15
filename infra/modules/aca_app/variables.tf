variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "app_name" {
  description = "Logical app name appended to the resource name (e.g. frontend, backend)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy the container app into."
  type        = string
}

variable "aca_env_id" {
  description = "Resource ID of the Azure Container Apps Environment."
  type        = string
}

variable "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  type        = string
}

variable "acr_login_server" {
  description = "Login server hostname of the ACR (e.g. myacr.azurecr.io)."
  type        = string
}

variable "image_name" {
  description = "Repository name for the container image inside ACR."
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy. Overridden by CI with the commit SHA."
  type        = string
}

variable "target_port" {
  description = "Port the container listens on."
  type        = number
}

variable "min_replicas" {
  description = "Minimum number of replicas."
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of replicas."
  type        = number
  default     = 3
}

variable "app_settings" {
  description = "Environment variables passed to the container."
  type        = map(string)
  default     = {}
}
