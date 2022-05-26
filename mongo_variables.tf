
/* Mongo API Variables*/
variable "mongo_dbs" {
  type = map(object({
    db_name           = string
    db_throughput     = number
    db_max_throughput = number
  }))
  description = "Map of Cosmos DB Mongo DBs to create. Some parameters are inherited from cosmos account."
  default     = {}
}

variable "mongo_db_collections" {
  type = map(object({
    collection_name           = string
    db_name                   = string
    default_ttl_seconds       = string
    shard_key                 = string
    collection_throughout     = number
    collection_max_throughput = number
    analytical_storage_ttl    = number
    indexes = map(object({
      mongo_index_keys   = list(string)
      mongo_index_unique = bool
    }))
  }))
  description = "List of Cosmos DB Mongo collections to create. Some parameters are inherited from cosmos account."
  default     = {}
}