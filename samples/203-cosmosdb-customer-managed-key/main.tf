# Azure provider version 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.84"
    }
  }
}

provider "azurerm" {
  features {}
}

# Acessing AzureRM provider configuration
data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "this" {
  display_name = "Azure Cosmos DB"
}


resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name                = "cosmosdb_uai"
}


resource "azurerm_key_vault" "this" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = var.sku_name

# Giving permissions resource creating SP to create keys
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "WrapKey",
      "UnwrapKey",
      "Create",
      "Update",
      "List",
      "Delete"
    ]
  }

# Permission for Cosmos DB Service Principle to get key
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_service_principal.this.id

    key_permissions = [
      "Get",
      "WrapKey",
      "UnwrapKey"
    ]
  }

# Permission for Cosmos DB User assigned identity to get key
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.this.client_id

    key_permissions = [
      "Get",
      "WrapKey",
      "UnwrapKey"
    ]
  }
}

resource "azurerm_key_vault_key" "this" {
  name         = var.key_vault_key_name
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}


module "azure_cosmos_db" {
  source                        = "../../modules/cosmos_db"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  cosmos_account_name           = var.cosmos_account_name
  cosmos_api                    = var.cosmos_api
  sql_dbs                       = var.sql_dbs
  sql_db_containers             = var.sql_db_containers
  key_vault_name                = azurerm_key_vault.this.name
  key_vault_rg_name             = azurerm_resource_group.this.name
  key_vault_key_name            = azurerm_key_vault_key.this.name
  identity = {
    enabled = true
    type    = "UserAssigned"
    id      = azurerm_user_assigned_identity.this.id
  }

  depends_on = [
    azurerm_resource_group.this,
    azurerm_user_assigned_identity.this,
    azurerm_key_vault.this,
    azurerm_key_vault_key.this
  ]
}
