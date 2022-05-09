output "cosmosdb_account_id" {
  value = module.azure_cosmos_db.cosmosdb_id
}

output "cosmosdb_endpoint" {
  value = module.azure_cosmos_db.cosmosdb_endpoint
}

output "cosmosdb_read_endpoint" {
  value = module.azure_cosmos_db.cosmosdb_read_endpoint
}

output "cosmosdb_write_endpoint" {
  value = module.azure_cosmos_db.cosmosdb_write_endpoint
}

output "cosmosdb_primary_key" {
  value     = module.azure_cosmos_db.cosmosdb_primary_key
  sensitive = true
}

output "cosmosdb_secondary_key" {
  value     = module.azure_cosmos_db.cosmosdb_secondary_key
  sensitive = true
}

output "cosmosdb_primary_readonly_key" {
  value     = module.azure_cosmos_db.cosmosdb_primary_readonly_key
  sensitive = true
}

output "cosmosdb_secondary_readonly_key" {
  value     = module.azure_cosmos_db.cosmosdb_secondary_readonly_key
  sensitive = true
}

output "cosmosdb_connection_strings" {
  value     = module.azure_cosmos_db.cosmosdb_connection_strings
  sensitive = true
}

output "sql_db_id" {
  value = module.azure_cosmos_db.sql_db_id
}

output "sql_container_id" {
  value = module.azure_cosmos_db.sql_containers_id
}
