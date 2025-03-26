variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of resources."
  type        = string
}

variable "aks_name" {
  description = "name for aks module"
  type        = string
}

variable "node_pool_name" {
  description = "name for node pool in cluster"
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

variable "key_vault_id" {
  description = "The ID of the KeyVault."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}
