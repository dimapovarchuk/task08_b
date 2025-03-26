output "aca_fqdn" {
  description = "The FQDN for the Azure Container App"
  value       = azurerm_container_app.container_app.latest_revision_fqdn
}

