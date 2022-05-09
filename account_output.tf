# Output account reference 
output "cosmos-db-id" {
  value = azurerm_cosmosdb_account.this.id
}

output "cosmos-db-endpoint" {
  value = azurerm_cosmosdb_account.this.endpoint
}

output "cosmos-db-read_endpoint" {
  value = azurerm_cosmosdb_account.this.read_endpoints
}

output "cosmos-db-write_endpoint" {
  value = azurerm_cosmosdb_account.this.write_endpoints
}

output "cosmos-db-primary_key" {
  value     = azurerm_cosmosdb_account.this.primary_key
  sensitive = true
}

output "cosmos-db-secondary_key" {
  value     = azurerm_cosmosdb_account.this.secondary_key
  sensitive = true
}

output "cosmos-db-primary_readonly_key" {
  value     = azurerm_cosmosdb_account.this.primary_readonly_key
  sensitive = true
}

output "cosmos-db-secondary_readonly_key" {
  value     = azurerm_cosmosdb_account.this.secondary_readonly_key
  sensitive = true
}

output "cosmos-db-connection_strings" {
  value     = azurerm_cosmosdb_account.this.connection_strings
  sensitive = true
}

output "cosmosdb_systemassigned_identity" {
  value = enable_systemassigned_identity ? zipmap(["tenant_id", "principal_id"], [azurerm_cosmosdb_account.this.identity[0].tenant_id, azurerm_cosmosdb_account.this.identity[0].principal_id]) : {}
}