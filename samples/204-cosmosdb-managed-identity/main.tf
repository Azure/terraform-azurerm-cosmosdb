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
  location = azurerm_resource_group.this.location 
  name = "cosmosdb_uai"
}

/* 
Notes for different managed identity settings
 - Set identity.type = "SystemAssigned" and id ="" for system-assigned only
 - Set identity.type = "UserAssigned" and id = azurerm_user_assigned_identity.this.id for user-assigned only 
 - Set identity.type = "SystemAssigned,UserAssigned" and id = azurerm_user_assigned_identity.this.id  for both user and system assigned identity
*/ 
module "azure_cosmos_db" {
  source              = "../../modules/cosmos_db"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers
  identity = {
    enabled = true 
    type = "UserAssigned" 
    id = azurerm_user_assigned_identity.this.id
  }
  depends_on = [
    azurerm_resource_group.this,
    azurerm_user_assigned_identity.this 
  ]
}