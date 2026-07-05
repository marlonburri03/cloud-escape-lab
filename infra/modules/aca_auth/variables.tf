variable "container_app_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "container_app_deployment_token" {
  description = "Stable token derived from the desired container app deployment config. Changes force EasyAuth to be re-applied after frontend app updates."
  type        = string
}
