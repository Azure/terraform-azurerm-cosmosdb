# Private endpoint variables 
variable "private_endpoint" {
  type = map(object({
    name                            = string
    vnet_rg_name                    = string
    vnet_name                       = string
    subnet_name                     = string
    dns_zone_rg_name                = string
    enable_private_dns_entry        = bool
    dns_zone_group_name             = string
    private_service_connection_name = string
    is_manual_connection            = bool
  }))
  description = "Parameters for private endpoint creation"
  default     = {}
}

variable "pe_subresource" {
  type        = map(any)
  description = "Map of subresources to choose appropriate Private Endpoint sub resource for DB API"
  default = {
    sql       = "SQL"
    table     = "Table"
    gremlin   = "Gremlin"
    mongo     = "MongoDB"
    cassandra = "Cassandra"
  }
}

variable "private_dns_zone_name" {
  type        = map(any)
  description = "Map of the private DNS zone to choose approrite Private DNS Zone for DB API."
  default = {
    sql       = "privatelink.documents.azure.com"
    table     = "privatelink.table.cosmos.azure.com"
    gremlin   = "privatelink.gremlin.cosmos.azure.com"
    mongo     = "privatelink.mongo.cosmos.azure.com"
    cassandra = "privatelink.cassandra.cosmos.azure.com"
  }
}