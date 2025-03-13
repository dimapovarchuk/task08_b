data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "storage" {
  source = "./modules/storage"

  sa_name             = local.sa_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  tags                = var.tags
}

module "acr" {
  source = "./modules/acr"

  image_name                = local.app_image
  acr_name                  = local.acr_name
  resource_group_name       = azurerm_resource_group.resource_group.name
  location                  = azurerm_resource_group.resource_group.location
  acr_sku                   = "Basic"
  context_repo_path         = module.storage.sa_archive
  context_repo_access_token = module.storage.sas_token
  tags                      = var.tags

  depends_on = [
    module.storage
  ]
}

module "keyvault" {
  source = "./modules/keyvault"

  keyvault_name          = local.keyvault_name
  keyvault_sku_name      = "standard"
  resource_group_name    = azurerm_resource_group.resource_group.name
  location               = azurerm_resource_group.resource_group.location
  tenant_id              = data.azurerm_client_config.current.tenant_id
  current_user_object_id = data.azurerm_client_config.current.object_id
  tags                   = var.tags
}

module "redis_cache" {
  source = "./modules/aci_redis"

  redis_name                    = local.redis_aci_name
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = azurerm_resource_group.resource_group.location
  kv_id                         = module.keyvault.key_vault_id
  redis_hostname_secret_name    = var.redis_hostname_secret_name
  redis_primary_key_secret_name = var.redis_primary_key_secret_name
  tags                          = var.tags

  depends_on = [
    module.acr,
    module.keyvault
  ]
}

module "aca-app" {
  source = "./modules/aca"

  aca_name                      = local.aca_name
  aca_env_name                  = local.aca_env_name
  acr_id                        = module.acr.acr_id
  acr_login_server              = module.acr.acr_login_server
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = azurerm_resource_group.resource_group.location
  app_image                     = "${module.acr.acr_login_server}/${local.app_image}"
  aca_env_workload_profile_name = "Consumption"
  aca_env_workload_profile_type = "Consumption"
  aca_workload_profile_name     = "Consumption"
  kv_id                         = module.keyvault.key_vault_id
  redis_url_secret_id           = module.redis_cache.redis_url_secret_id
  redis_password_secret_id      = module.redis_cache.redis_password_secret_id
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  tags                          = var.tags

  depends_on = [
    module.acr,
    module.redis_cache
  ]
}

module "aks" {
  source = "./modules/aks"

  aks_name            = local.aks_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  key_vault_id        = module.keyvault.key_vault_id
  acr_id              = module.acr.acr_id
  node_pool_name      = "system"
  tags                = var.tags

  depends_on = [
    module.acr,
    module.redis_cache
  ]
}

module "k8s-app-deployment" {
  source = "./modules/k8s"

  providers = {
    kubectl = kubectl
  }

  acr_login_server                = module.acr.acr_login_server
  image_name                      = local.app_image_name
  image_tag                       = local.app_image_tag
  keyvault_name                   = module.keyvault.key_vault_name
  aks_secret_provider_identity_id = module.aks.aks_secret_provider_user_assigned_identity_id
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  redis_hostname_secret           = var.redis_hostname_secret_name
  redis_primary_key_secret        = var.redis_primary_key_secret_name

  depends_on = [
    module.keyvault,
    module.aks,
    module.redis_cache,
    module.acr
  ]
}
