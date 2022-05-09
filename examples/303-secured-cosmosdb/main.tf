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

# Resource group 
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name                = "cosmosdb_uai"
}

# Key vault for CMK
resource "azurerm_key_vault" "this" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

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

# Key CMK Encryption
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

module "azure_cosmos_db" {
  source              = "Azure/cosmosdb/azurerm"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  geo_locations       = var.geo_locations
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers
  key_vault_name      = azurerm_key_vault.this.name
  key_vault_rg_name   = azurerm_resource_group.this.name
  key_vault_key_name  = azurerm_key_vault_key.this.name
  identity = {
    enabled = true
    type    = "UserAssigned"
    id      = azurerm_user_assigned_identity.this.id
  }
  private_endpoint = {
    "pe_endpoint" = {
      dns_zone_group_name             = var.dns_zone_group_name
      dns_zone_rg_name                = azurerm_private_dns_zone.this.resource_group_name
      is_manual_connection            = false
      name                            = var.pe_name
      private_service_connection_name = var.pe_connection_name
      subnet_name                     = azurerm_subnet.this.name
      vnet_name                       = azurerm_virtual_network.this.name
      vnet_rg_name                    = azurerm_resource_group.this.name
    }
  }
  depends_on = [
    azurerm_resource_group.this,
    azurerm_virtual_network.this,
    azurerm_subnet.this,
    azurerm_private_dns_zone.this,
    azurerm_private_dns_zone_virtual_network_link.this
  ]
}