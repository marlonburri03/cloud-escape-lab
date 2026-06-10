variable "resource_group_name" {
  description = "Resource group that hosts the Container App."
  type        = string
}

variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "app_name" {
  description = "Short purpose name appended to the Container App name (e.g. frontend, backend)."
  type        = string
}

variable "container_app_environment_id" {
  description = "ID of the Container App Environment to deploy into."
  type        = string
}

variable "acr_id" {
  description = "Resource ID of the ACR containing the app image."
  type        = string
}

variable "acr_login_server" {
  description = "Login server FQDN of the ACR (e.g. myacr.azurecr.io)."
  type        = string
}

variable "image_name" {
  description = "Repository name inside ACR (e.g. frontend)."
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy. Set by CI pipeline."
  type        = string
}

variable "app_port" {
  description = "TCP port the container listens on."
  type        = number
}

variable "external_ingress" {
  description = "Expose via the environment's internal LB (true = reachable from VNet/AppGW; false = env-internal only)."
  type        = bool
  default     = false
}

variable "max_replicas" {
  description = "Maximum number of replicas. Keep at 1 for SQLite-backed services."
  type        = number
  default     = 1
}

variable "env_vars" {
  description = "Environment variables injected into the container."
  type        = map(string)
  default     = {}
}
