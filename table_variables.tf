variable "tables" {
  type = map(object({
    table_name           = string
    table_throughput     = number
    table_max_throughput = number
  }))
  description = "Map of Cosmos DB Tables to create. Some parameters are inherited from cosmos account."
  default     = {}
}