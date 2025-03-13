variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of resources."
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
}

variable "context_repo_path" {
  description = "The URL of the archive in the Storage Account"
  type        = string
}

variable "context_repo_access_token" {
  description = "The token of the archive in the Storage Account"
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}

variable "image_name" {
  description = "The name of the app image"
  type        = string
}
