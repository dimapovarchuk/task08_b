variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure Container App Environment."
  type        = string
}

variable "location" {
  description = "The location for the Azure Container App Environment."
  type        = string
}

variable "aca_env_workload_profile_name" {
  description = "The workload profile name for the Azure Container App Environment."
  type        = string
}

variable "aca_env_workload_profile_type" {
  description = "The workload profile type for the Azure Container App Environment."
  type        = string
}

variable "aca_name" {
  description = "The name for the Azure Container App"
  type        = string
}

variable "acr_login_server" {
  description = "information about our azure container registry"
  type        = string
}

variable "kv_id" {
  description = "The ID of the Key Vault."
  type        = string
}

variable "redis_url_secret_id" {
  description = "ID of the secret of the redis url in key vault"
  type        = string
}

variable "redis_password_secret_id" {
  description = "ID of the secret of the redis password in key vault"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure subscription."
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}

variable "app_image" {
  description = "The image for the Azure Container App."
  type        = string
}

variable "aca_workload_profile_name" {
  description = "The workload profile name for the Azure Container App."
  type        = string
}

variable "aca_env_name" {
  description = "The name for the Azure Container App Environment"
  type        = string

}
