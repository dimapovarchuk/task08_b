# General
location    = "East US"
name_prefix = "cmtr-12345678-mod8"
tags = {
  Creator = "name_surname@epam.com"
}

# ACI
aci_sku = "Standard"

# ACR 
context_repo_path = "https://github.com/<username>/<repository>#task08/application"
acr_sku           = "Basic"

# KeyVault
keyvault_sku_name = "standard"

# Redis
redis_sku_name           = "Basic"
redis_hostname_secret    = "redis-hostname"
redis_primary_key_secret = "redis-primary-key"

