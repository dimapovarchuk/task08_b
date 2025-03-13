resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_container_group" "redis_container" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  os_type             = "Linux"
  dns_name_label      = var.redis_name
  sku                 = "Standard"

  container {
    name   = "${var.redis_name}-container"
    image  = "mcr.microsoft.com/cbl-mariner/base/redis:6.2"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 6379
      protocol = "TCP"
    }

    commands = [
      "redis-server",
      "--protected-mode no",
      "--requirepass ${random_password.password.result}"
    ]
  }
  tags = var.tags
}

resource "azurerm_key_vault_secret" "redis_password" {
  name         = var.redis_primary_key_secret_name
  value        = random_password.password.result
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "redis_hostname" {
  name         = var.redis_hostname_secret_name
  value        = azurerm_container_group.redis_container.fqdn
  key_vault_id = var.kv_id
}
