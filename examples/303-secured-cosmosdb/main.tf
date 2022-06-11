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

resource "azurerm_resource_group" "read_replica" {
  name     = var.resource_group_name_read_replica
  location = var.location_read_replica
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

# Virtual Network for private endpoint
resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "this" {
  name                                           = var.subnet_name
  resource_group_name                            = azurerm_resource_group.this.name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = var.subnet_prefixes
  enforce_private_link_endpoint_network_policies = true
}

# Private DNS Zone for SQL API
resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.private_dns_vnet_link_name
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}


# Read Replica Region Virtual Network for private endpoint
resource "azurerm_virtual_network" "read_replica" {
  name                = var.virtual_network_name_read_replica
  resource_group_name = azurerm_resource_group.read_replica.name
  location            = azurerm_resource_group.read_replica.location
  address_space       = var.vnet_address_space_read_replica
}

resource "azurerm_subnet" "read_replica" {
  name                                           = var.subnet_name_read_replica
  resource_group_name                            = azurerm_resource_group.read_replica.name
  virtual_network_name                           = azurerm_virtual_network.read_replica.name
  address_prefixes                               = var.subnet_prefixes_read_replica
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "azure_cosmos_db" {
  source                         = "Azure/cosmosdb/azurerm"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  cosmos_account_name            = var.cosmos_account_name
  cosmos_api                     = var.cosmos_api
  geo_locations                  = var.geo_locations
  sql_dbs                        = var.sql_dbs
  sql_db_containers              = var.sql_db_containers
  key_vault_name                 = azurerm_key_vault.this.name
  key_vault_rg_name              = azurerm_resource_group.this.name
  key_vault_key_name             = azurerm_key_vault_key.this.name
  enable_systemassigned_identity = true
  private_endpoint = {
    "pe_endpoint" = {
      dns_zone_group_name             = var.dns_zone_group_name
      dns_zone_rg_name                = azurerm_private_dns_zone.this.resource_group_name
      enable_private_dns_entry        = true
      is_manual_connection            = false
      name                            = var.pe_name
      private_service_connection_name = var.pe_connection_name
      subnet_name                     = azurerm_subnet.this.name
      vnet_name                       = azurerm_virtual_network.this.name
      vnet_rg_name                    = azurerm_resource_group.this.name
    }
    "pe_endpoint_read_replica" = {
      dns_zone_group_name             = var.dns_zone_group_name
      dns_zone_rg_name                = azurerm_private_dns_zone.this.resource_group_name
      enable_private_dns_entry        = false
      is_manual_connection            = false
      name                            = var.pe_name_read_replica
      private_service_connection_name = var.pe_connection_name_read_replica
      subnet_name                     = azurerm_subnet.read_replica.name
      vnet_name                       = azurerm_virtual_network.read_replica.name
      vnet_rg_name                    = azurerm_resource_group.read_replica.name
    }
  }

  log_analytics = {
    workspace = {
      la_workspace_name    = azurerm_log_analytics_workspace.this.name
      la_workspace_rg_name = azurerm_log_analytics_workspace.this.resource_group_name
    }
  }
  depends_on = [
    azurerm_resource_group.this,
    azurerm_key_vault.this,
    azurerm_key_vault_key.this,
    azurerm_key_vault_access_policy.cosmosdb_identity,
    azurerm_virtual_network.this,
    azurerm_subnet.this,
    azurerm_private_dns_zone.this,
    azurerm_private_dns_zone_virtual_network_link.this
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
