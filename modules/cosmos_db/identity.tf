# Existing Cosmos DB AzureRM provider only supported SystemAssigned Identity. Below block enables the options for both system and user assigned managed identities.
# Type specification: "SystemAssigned", "UserAssigned" or "SystemAssigned,UserAssigned"
resource "azapi_update_resource" "managed_identity_enable" {
  count       = var.identity.enabled ? 1 : 0
  type        = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  resource_id = azurerm_cosmosdb_account.this.id
  body        = local.identity_body
}

resource "azapi_update_resource" "managed_identity_disable" {
  count       = var.identity.enabled ? 0 : 1
  type        = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  resource_id = azurerm_cosmosdb_account.this.id
  body = jsonencode({
    identity = {
      type = "None"
    }
  })
}