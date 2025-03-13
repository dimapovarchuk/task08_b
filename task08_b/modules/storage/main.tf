data "archive_file" "dotfiles" {
  type        = "tar.gz"
  source_dir  = "${path.root}/application"
  output_path = "${path.root}/app.tar.gz"
}

resource "time_static" "sas_start_time" {
}

resource "time_offset" "sas_expiry_time" {
  offset_years = 1
}

resource "azurerm_storage_account" "sa" {
  name                          = var.sa_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  shared_access_key_enabled     = true
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_storage_container" "sa_container" {
  name                  = "app-content"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "sa_blob_app" {
  name                   = "app.tar.gz"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.sa_container.name
  type                   = "Block"
  source                 = "${path.root}/app.tar.gz"
}

data "azurerm_storage_account_blob_container_sas" "sas_token" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  container_name    = azurerm_storage_container.sa_container.name
  https_only        = true

  start  = time_static.sas_start_time.rfc3339
  expiry = time_offset.sas_expiry_time.rfc3339
  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = true
  }
}
