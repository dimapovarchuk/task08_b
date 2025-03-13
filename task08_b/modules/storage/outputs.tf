output "sa_access_key" {
  description = "storage account primary access key"
  value       = azurerm_storage_account.sa.primary_access_key
}

output "sa_container_name" {
  description = "storage account container for this task"
  value       = azurerm_storage_container.sa_container.name
}

output "sa_primary_blob_endpoint" {
  description = "storage account blob url"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "sa_archive" {
  description = "archive with all required files"
  value       = azurerm_storage_blob.sa_blob_app.url
}

output "sas_token" {
  description = "storage account container sas token"
  value       = data.azurerm_storage_account_blob_container_sas.sas_token.sas
  sensitive   = true
}

output "sa_id" {
  description = "id of the storage account"
  value       = azurerm_storage_account.sa.id
}
