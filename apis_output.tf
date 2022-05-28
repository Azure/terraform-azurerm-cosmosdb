# Output SQL reference 
output "sql_db_id" {
  value       = [for sql_db_id in azurerm_cosmosdb_sql_database.this : zipmap([sql_db_id.name], [sql_db_id.id])]
  description = "SQL API DB IDs"
}

output "sql_containers_id" {
  value       = [for sql_container_id in azurerm_cosmosdb_sql_container.this : zipmap([sql_container_id.name], [sql_container_id.id])]
  description = "SQL API Container IDs"
}

# Output Cassandra reference 
output "cassandra_keyspace_id" {
  value       = [for cassandra_keyspace_id in azurerm_cosmosdb_cassandra_keyspace.this : zipmap([cassandra_keyspace_id.name], [cassandra_keyspace_id.id])]
  description = "Cassandra API Keyspace IDs"
}

output "cassandra_table_id" {
  value       = [for cassandra_table_id in azurerm_cosmosdb_cassandra_table.this : zipmap([cassandra_table_id.name], [cassandra_table_id.id])]
  description = "Cassandra API Table IDs"
}

# Output Gremlin reference 
output "gremlin_db_id" {
  value       = [for gremlin_db_id in azurerm_cosmosdb_gremlin_database.this : zipmap([gremlin_db_id.name], [gremlin_db_id.id])]
  description = "Gremlin API DB IDs"
}

output "gremlin_graph_id" {
  value       = [for gremlin_graph_id in azurerm_cosmosdb_gremlin_graph.this : zipmap([gremlin_graph_id.name], [gremlin_graph_id.id])]
  description = "Gremlin API Graph IDs"
}

# Output Mongo reference 
output "mongo_db_id" {
  value       = [for mongo_db_id in azurerm_cosmosdb_mongo_database.this : zipmap([mongo_db_id.name], [mongo_db_id.id])]
  description = "Mongo API DB IDs"
}

output "mongo_db_collection_id" {
  value       = [for mongo_db_collection_id in azurerm_cosmosdb_mongo_collection.this : zipmap([mongo_db_collection_id.name], [mongo_db_collection_id.id])]
  description = "Mongo API Collection IDs"
}

# Output Table reference 
output "table_id" {
  value       = [for table_id in azurerm_cosmosdb_table.this : zipmap([table_id.name], [table_id.id])]
  description = "Table API Table IDs"
}