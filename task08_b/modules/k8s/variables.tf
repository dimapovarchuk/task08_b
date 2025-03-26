variable "tenant_id" {
  description = "The tenant ID for the Azure subscription."
  type        = string
}

variable "keyvault_name" {
  description = "The Key Vault Name."
  type        = string
}

variable "aks_secret_provider_identity_id" {
  description = "The AKS secret provider user assigned identity id."
  type        = string
}

variable "acr_login_server" {
  description = "The ACR login server."
  type        = string
}

variable "redis_primary_key_secret" {
  description = "Name of the secret for the Redis primary key in Azure Key Vault."
  type        = string
}

variable "redis_hostname_secret" {
  description = "Name of the secret for the Redis hostname in Azure Key Vault."
  type        = string
}

variable "image_name" {
  description = "The image name for the k8s deployment."
  type        = string
}

variable "image_tag" {
  description = "The image tag for the k8s deployment."
  type        = string
}

variable "deploy_kubernetes_resources" {
  description = "Whether to deploy kubernetes resources"
  type        = bool
  default     = false
}