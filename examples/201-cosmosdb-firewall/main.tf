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


module "azure_cosmos_db" {
  source                        = "Azure/cosmosdb/azurerm"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  cosmos_account_name           = var.cosmos_account_name
  cosmos_api                    = var.cosmos_api
  sql_dbs                       = var.sql_dbs
  sql_db_containers             = var.sql_db_containers
  public_network_access_enabled = var.public_network_access_enabled
  ip_firewall_enabled           = var.ip_firewall_enabled
  firewall_ip                   = var.firewall_ip
  depends_on = [
    azurerm_resource_group.this
  ]
}