variable "application_name" {
  type = string
}

variable "redirect_uris" {
  type = list(string)
}

variable "owner_object_ids" {
  description = "Map of label → object ID (users or service principals) to add as owners of the app registration."
  type        = map(string)
  default     = {}
}
