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

# Resource group 
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "azure_cosmos_db" {
  source = "../../../azure-cosmosdb-terraform-repo"
  #source              = "Azure/cosmosdb/azurerm"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  cassandra_keyspaces = var.cassandra_keyspaces
  cassandra_tables    = var.cassandra_tables
  depends_on = [
    azurerm_resource_group.this
  ]
}