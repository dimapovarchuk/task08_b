# General
location    = "East US"
name_prefix = "cmtr-000000di-mod8"
tags = {
  Creator = "dmytro_povarchuk@epam.com"
}

# ACI
aci_sku = "Standard"

# ACR 
#context_repo_path = "https://github.com/dimapovarchuk/task08#task08/application"
context_repo_path = "https://github.com/dimapovarchuk/task08_b#main:task08_b/application"
acr_sku           = "Basic"

# KeyVault
keyvault_sku_name = "standard"

# Redis
redis_sku_name           = "Basic"
redis_hostname_secret    = "redis-hostname"
redis_primary_key_secret = "redis-primary-key"

########################################################################################
#location = "Central US"

#name_prefix = "${resources_name_prefix}"

#redis_hostname_secret_name    = "${redis_hostname}"
#redis_primary_key_secret_name = "${redis_password}"
#tags = {
#  Creator = "${student_email}"
#}