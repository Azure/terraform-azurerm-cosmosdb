/* Gremlin API Variables*/
variable "gremlin_dbs" {
  type = map(object({
    db_name           = string
    db_throughput     = number
    db_max_throughput = number
  }))
  description = "Map of Cosmos DB Gremlin DBs to create. Some parameters are inherited from cosmos account."
  default     = {}
}

variable "gremlin_graphs" {
  type = map(object({
    graph_name                        = string
    db_name                           = string
    partition_key_path                = string
    partition_key_version             = number
    default_ttl_seconds               = string
    graph_throughput                  = number
    graph_max_throughput              = number
    gremlin_automatic_indexing_policy = bool
    gremlin_indexing_mode             = string
    gremlin_included_paths            = list(string)
    gremlin_excluded_paths            = list(string)
    gremlin_conflict_resolution_mode  = string
    gremlin_conflict_resolution_path  = string
    gremlin_unique_key                = list(string)
  }))
  description = "List of Cosmos DB Gremlin Graph to create. Some parameters are inherited from cosmos account."
  default     = {}
}