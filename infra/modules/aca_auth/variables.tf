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

variable "container_app_revision" {
  description = "Latest revision name of the container app. Changes on every new deployment to re-apply auth settings."
  type        = string
}
