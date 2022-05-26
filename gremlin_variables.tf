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
    graph_name            = string
    db_name               = string
    partition_key_path    = string
    partition_key_version = number
    default_ttl_seconds   = string
    graph_throughput      = number
    graph_max_throughput  = number
    index_policy_settings = object({
      indexing_automatic = bool
      indexing_mode      = string
      included_paths     = list(string)
      excluded_paths     = list(string)
      composite_indexes = map(object({
        indexes = set(object({
          index_path  = string
          index_order = string
        }))
      }))
      spatial_indexes = map(object({
        spatial_index_path = string
      }))
    })
    conflict_resolution_policy = object({
      mode      = string
      path      = string
      procedure = string
    })
    unique_key = list(string)
  }))
  description = "List of Cosmos DB Gremlin Graph to create. Some parameters are inherited from cosmos account."
  default     = {}
}