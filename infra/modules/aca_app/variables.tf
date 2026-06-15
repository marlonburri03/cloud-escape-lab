<<<<<<< HEAD
variable "resource_group_name" {
  description = "Resource group that hosts the Container App."
  type        = string
}

=======
>>>>>>> 35b35a3 (S3M-25: format files)
variable "name_prefix" {
  description = "Naming prefix used across resources."
  type        = string
}

variable "app_name" {
<<<<<<< HEAD
  description = "Short purpose name appended to the Container App name (e.g. frontend, backend)."
  type        = string
}

variable "container_app_environment_id" {
  description = "ID of the Container App Environment to deploy into."
=======
  description = "Logical app name appended to the resource name (e.g. frontend, backend)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy the container app into."
  type        = string
}

variable "aca_env_id" {
  description = "Resource ID of the Azure Container Apps Environment."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = string
}

variable "acr_id" {
<<<<<<< HEAD
  description = "Resource ID of the ACR containing the app image."
=======
  description = "Resource ID of the Azure Container Registry."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = string
}

variable "acr_login_server" {
<<<<<<< HEAD
  description = "Login server FQDN of the ACR (e.g. myacr.azurecr.io)."
=======
  description = "Login server hostname of the ACR (e.g. myacr.azurecr.io)."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = string
}

variable "image_name" {
<<<<<<< HEAD
  description = "Repository name inside ACR (e.g. frontend)."
=======
  description = "Repository name for the container image inside ACR."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = string
}

variable "image_tag" {
<<<<<<< HEAD
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
=======
  description = "Image tag to deploy. Overridden by CI with the commit SHA."
  type        = string
}

variable "target_port" {
  description = "Port the container listens on."
  type        = number
}

variable "min_replicas" {
  description = "Minimum number of replicas."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = number
  default     = 1
}

<<<<<<< HEAD
variable "env_vars" {
  description = "Environment variables injected into the container."
=======
variable "max_replicas" {
  description = "Maximum number of replicas."
  type        = number
  default     = 3
}

variable "app_settings" {
  description = "Environment variables passed to the container."
>>>>>>> 35b35a3 (S3M-25: format files)
  type        = map(string)
  default     = {}
}
