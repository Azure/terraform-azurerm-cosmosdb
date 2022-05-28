# Output account reference 
output "cosmosdb_id" {
  value       = azurerm_cosmosdb_account.this.id
  description = "Cosmos DB Account ID"
}

output "cosmosdb_endpoint" {
  value       = azurerm_cosmosdb_account.this.endpoint
  description = "Cosmos DB Endpoint"
}

output "cosmosdb_read_endpoint" {
  value       = azurerm_cosmosdb_account.this.read_endpoints
  description = "Cosmos DB Read Endpoint"
}

output "cosmosdb_write_endpoint" {
  value       = azurerm_cosmosdb_account.this.write_endpoints
  description = "Cosmos DB Write Endpoint"
}

output "cosmosdb_primary_key" {
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
  description = "Cosmos DB Primary Keys"
}

output "cosmosdb_secondary_key" {
  value       = azurerm_cosmosdb_account.this.secondary_key
  sensitive   = true
  description = "Cosmos DB Secondary Keys"
}

output "cosmosdb_primary_readonly_key" {
  value       = azurerm_cosmosdb_account.this.primary_readonly_key
  sensitive   = true
  description = "Cosmos DB Primary Read Only Keys"
}

output "cosmosdb_secondary_readonly_key" {
  value       = azurerm_cosmosdb_account.this.secondary_readonly_key
  sensitive   = true
  description = "Cosmos DB Secondary Read Only Keys"
}

output "cosmosdb_connection_strings" {
  value       = azurerm_cosmosdb_account.this.connection_strings
  sensitive   = true
  description = "Cosmos DB Connection Strings"
}

output "cosmosdb_systemassigned_identity" {
  value       = var.enable_systemassigned_identity ? zipmap(["tenant_id", "principal_id"], [azurerm_cosmosdb_account.this.identity[0].tenant_id, azurerm_cosmosdb_account.this.identity[0].principal_id]) : {}
  description = "Cosmos DB System Assigned Identity (Tenant ID and Principal ID)"
}