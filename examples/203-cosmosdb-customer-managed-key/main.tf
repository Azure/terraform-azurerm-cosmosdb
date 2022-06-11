# Azure provider version 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azapi" {}

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

resource "azurerm_key_vault" "this" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  sku_name                   = var.sku_name
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "cosmosdb_identity" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.this.id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]

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
  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}

module "azure_cosmos_db" {
  source                         = "Azure/cosmosdb/azurerm"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  cosmos_account_name            = var.cosmos_account_name
  cosmos_api                     = var.cosmos_api
  sql_dbs                        = var.sql_dbs
  sql_db_containers              = var.sql_db_containers
  key_vault_name                 = azurerm_key_vault.this.name
  key_vault_rg_name              = azurerm_resource_group.this.name
  key_vault_key_name             = azurerm_key_vault_key.this.name
  enable_systemassigned_identity = true

  depends_on = [
    azurerm_resource_group.this,
    azurerm_key_vault.this,
    azurerm_key_vault_key.this,
    azurerm_key_vault_access_policy.cosmosdb_identity,
  ]
}

/*
  AzureRM Cosmos DB currently only supports default_identity_type = FirstPartyIdentity on-creation for customer managed keys. 
  SystemAssigned and UserAssigned can be set after the fact. Consequently, we have a lifecycle ignore policy for default_identity_type.
  Below example demonstrates setting SystemAssigned Identity afterwards when the identity is instantiated along with cosmos db.
*/
resource "azurerm_key_vault_access_policy" "cosmosdb_systemassigned_identity" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = module.azure_cosmos_db.cosmosdb_systemassigned_identity.tenant_id
  object_id    = module.azure_cosmos_db.cosmosdb_systemassigned_identity.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
  depends_on = [
    module.azure_cosmos_db
  ]
}

resource "azapi_update_resource" "update_default_identity" {
  type        = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  resource_id = module.azure_cosmos_db.cosmosdb_id
  body = jsonencode({
    properties = {
      defaultIdentity = "SystemAssignedIdentity"
    }
  })
  depends_on = [
    azurerm_key_vault_access_policy.cosmosdb_systemassigned_identity
  ]
}