# Output SQL reference 
output "sql-db-id" {
  value = [for sql_db_id in azurerm_cosmosdb_sql_database.this : zipmap([sql_db_id.name], [sql_db_id.id])]
}

output "sql-containers-id" {
  value = [for sql_container_id in azurerm_cosmosdb_sql_container.this : zipmap([sql_container_id.name], [sql_container_id.id])]
}

# Output Cassandra reference 
output "cassandra-keyspace-id" {
  value = [for cassandra-keyspace-id in azurerm_cosmosdb_cassandra_keyspace.this : zipmap([cassandra-keyspace-id.name], [cassandra-keyspace-id.id])]
}

output "cassandra-table-id" {
  value = [for cassandra-table-id in azurerm_cosmosdb_cassandra_table.this : zipmap([cassandra-table-id.name], [cassandra-table-id.id])]
}

# Output Gremlin reference 
output "gremlin-db-id" {
  value = [for gremlin-db-id in azurerm_cosmosdb_gremlin_database.this : zipmap([gremlin-db-id.name], [gremlin-db-id.id])]
}

output "gremlin-graph-id" {
  value = [for gremlin-graph-id in azurerm_cosmosdb_gremlin_graph.this : zipmap([gremlin-graph-id.name], [gremlin-graph-id.id])]
}

# Output Mongo reference 
output "mongo-db-id" {
  value = [for mongo-db-id in azurerm_cosmosdb_mongo_database.this : zipmap([mongo-db-id.name], [mongo-db-id.id])]
}

output "mongo-db-collection-id" {
  value = [for mongo-db-collection-id in azurerm_cosmosdb_mongo_collection.this : zipmap([mongo-db-collection-id.name], [mongo-db-collection-id.id])]
}

# Output Table reference 
output "table-id" {
  value = [for table-id in azurerm_cosmosdb_table.this : zipmap([table-id.name], [table-id.id])]
}