variable "name" {
  description = "Name of the managed identity."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy the managed identity into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID where Contributor and UAA roles are assigned."
  type        = string
}

variable "storage_account_id" {
  description = "Storage account ID for the Terraform state — identity gets Storage Blob Data Contributor."
  type        = string
}

variable "gitlab_project_path" {
  description = "Full GitLab project path (group/subgroup/project) used as OIDC subject."
  type        = string
}
