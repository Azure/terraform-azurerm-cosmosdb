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
  sensitive = false
}

output "cosmos-db-secondary_key" {
  value     = azurerm_cosmosdb_account.this.secondary_key
  sensitive = false
}