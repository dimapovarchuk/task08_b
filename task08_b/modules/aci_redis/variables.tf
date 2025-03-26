variable "redis_name" {
  description = "name of redis aci"
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

variable "kv_id" {
  description = "The ID of the Key Vault."
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

