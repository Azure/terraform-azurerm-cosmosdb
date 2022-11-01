# Azure provider version 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network for private endpoint 
resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "this" {
  name                                      = var.subnet_name
  resource_group_name                       = azurerm_resource_group.this.name
  virtual_network_name                      = azurerm_virtual_network.this.name
  address_prefixes                          = var.subnet_prefixes
  private_endpoint_network_policies_enabled = true
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
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers
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
  }
  depends_on = [
    azurerm_resource_group.this,
    azurerm_virtual_network.this,
    azurerm_subnet.this,
    azurerm_private_dns_zone.this,
    azurerm_private_dns_zone_virtual_network_link.this
  ]
}
