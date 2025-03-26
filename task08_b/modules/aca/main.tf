resource "azurerm_user_assigned_identity" "identity_aca" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.aca_name}-mi"
}

resource "azurerm_key_vault_access_policy" "identity_access_policy" {
  key_vault_id = var.kv_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.identity_aca.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_role_assignment" "aca_acrpull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.identity_aca.principal_id
}

resource "azurerm_container_app_environment" "app_env" {
  name                = var.aca_env_name
  resource_group_name = var.resource_group_name
  location            = var.location

  workload_profile {
    name                  = var.aca_env_workload_profile_name
    workload_profile_type = var.aca_env_workload_profile_type
  }

  tags = var.tags
}

resource "azurerm_container_app" "container_app" {
  name                         = var.aca_name
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = var.aca_workload_profile_name

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.identity_aca.id
    ]
  }

  # https://learn.microsoft.com/en-us/azure/container-apps/manage-secrets?tabs=azure-portal#reference-secret-from-key-vault

  secret {
    name                = "redis-url"
    identity            = azurerm_user_assigned_identity.identity_aca.id
    key_vault_secret_id = var.redis_url_secret_id
  }

  secret {
    name                = "redis-key"
    identity            = azurerm_user_assigned_identity.identity_aca.id
    key_vault_secret_id = var.redis_password_secret_id
  }

  registry {
    server   = var.acr_login_server
    identity = azurerm_user_assigned_identity.identity_aca.id
  }

  template {
    container {
      name   = "application"
      image  = var.app_image
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "CREATOR"
        value = "ACA"
      }
      env {
        name  = "REDIS_PORT"
        value = "6379"
      }
      env {
        name        = "REDIS_URL"
        secret_name = "redis-url"
      }
      env {
        name        = "REDIS_PWD"
        secret_name = "redis-key"
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    transport                  = "auto"
    target_port                = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}
