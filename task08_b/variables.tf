variable "location" {
  description = "The location of resources"
  type        = string
}

variable "name_prefix" {
  description = "general prefix for all resources in this task"
  type        = string
}

variable "redis_primary_key_secret_name" {
  description = "Name of the secret for the Redis primary key in Azure Key Vault."
  type        = string
}

variable "redis_hostname_secret_name" {
  description = "Name of the secret for the Redis hostname in Azure Key Vault."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}

variable "deploy_kubernetes_resources" {
  description = "Whether to deploy kubernetes resources"
  type        = bool
  default     = false
}