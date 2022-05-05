output "cosmos-db-account-id" {
  value = module.azure_cosmos_db.cosmos-db-id
}

output "cosmos-db-endpoint" {
  value = module.azure_cosmos_db.cosmos-db-endpoint
}

output "cosmos-db-read_endpoint" {
  value = module.azure_cosmos_db.cosmos-db-read_endpoint
}

output "cosmos-db-write_endpoint" {
  value = module.azure_cosmos_db.cosmos-db-write_endpoint
}

output "cosmos-db-primary_key" {
  value     = module.azure_cosmos_db.cosmos-db-primary_key
  sensitive = true
}

output "cosmos-db-secondary_key" {
  value     = module.azure_cosmos_db.cosmos-db-secondary_key
  sensitive = true
}

output "cosmos-db-primary_readonly_key" {
  value     = module.azure_cosmos_db.cosmos-db-primary_readonly_key
  sensitive = true
}

output "cosmos-db-secondary_readonly_key" {
  value     = module.azure_cosmos_db.cosmos-db-secondary_readonly_key
  sensitive = true
}

output "cosmos-db-connection_strings" {
  value     = module.azure_cosmos_db.cosmos-db-connection_strings
  sensitive = true
}

output "sql-db-id" {
  value = module.azure_cosmos_db.sql-db-id
}

output "sql-container-id" {
  value = module.azure_cosmos_db.sql-containers-id
}
