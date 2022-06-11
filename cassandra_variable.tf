/* Cassandra API Variables*/
variable "cassandra_keyspaces" {
  type = map(object({
    keyspace_name           = string
    keyspace_throughput     = number
    keyspace_max_throughput = number
  }))
  description = "List of Cosmos DB Cassandra keyspaces to create. Some parameters are inherited from cosmos account."
  default     = {}
}

variable "cassandra_tables" {
  type = map(object({
    table_name             = string
    keyspace_name          = string
    default_ttl_seconds    = string
    analytical_storage_ttl = number
    table_throughout       = number
    table_max_throughput   = number
    cassandra_schema_settings = object({
      column = map(object({
        column_key_name = string
        column_key_type = string
      }))
      partition_key = map(object({
        partition_key_name = string
      }))
      cluster_key = map(object({
        cluster_key_name     = string
        cluster_key_order_by = string
      }))
    })
  }))
  description = "List of Cosmos DB Cassandra tables to create. Some parameters are inherited from cosmos account."
  default     = {}
}