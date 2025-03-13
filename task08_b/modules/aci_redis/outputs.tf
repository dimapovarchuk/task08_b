output "redis_url" {
  description = "redis url for following working with this instance"
  value       = azurerm_container_group.redis_container.fqdn
}

output "redis_ip" {
  description = "redis ip for following working with this instance"
  value       = azurerm_container_group.redis_container.ip_address
}

output "redis_url_secret_id" {
  description = "ID of the secret of the redis url in key vault"
  value       = azurerm_key_vault_secret.redis_hostname.id
}

output "redis_password_secret_id" {
  description = "ID of the secret of the redis password in key vault"
  value       = azurerm_key_vault_secret.redis_password.id
}

output "redis_id" {
  description = "id of the redis container"
  value       = azurerm_container_group.redis_container.id
}
