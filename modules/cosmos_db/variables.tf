variable "resource_group_name" {
  type        = string
  description = "Name of the azure resource group."
}

variable "location" {
  type        = string
  description = "Cosmos DB deployment region. Can be different vs. RG location"
  default     = ""
}

variable "cosmos_account_name" {
  type        = string
  description = "Name of the Cosmos DB account."
  default     = ""
}

variable "cosmos_api" {
  type        = string
  description = ""
  validation {
    condition     = contains(["sql", "table", "cassandra", "mongo", "gremlin"], lower(var.cosmos_api))
    error_message = "Unsupported cosmos api specified. Supported APIs include sql, table, cassandra, mongo and gremlin."
  }
}

variable "analytical_storage" {
  type = object({
    enabled     = bool
    schema_type = string
  })
  description = "Analytical storage enablement."
  default = {
    enabled     = false
    schema_type = null
  }
}

variable "application_name" {
  type        = string
  description = "Name of the application."
  default     = "dev"
}

variable "environment" {
  type        = string
  description = "Name of the environment. Example dev, test, qa, cert, prod etc...."
  default     = "dev"
}

variable "consistency_level" {
  type        = string
  description = "The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix"
  default     = "Eventual"
}

variable "max_interval_in_seconds" {
  type        = string
  description = "When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Accepted range for this value is 5 - 86400 (1 day)"
  default     = 300
}

variable "max_staleness_prefix" {
  type        = string
  description = "When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Accepted range for this value is 10 – 2147483647"
  default     = 100000
}

variable "auto_failover" {
  type        = bool
  description = "Enable automatic fail over for this Cosmos DB account - can be either true or false"
  default     = false
}

variable "free_tier" {
  type        = bool
  description = "Enable Free Tier pricing option for this Cosmos DB account - can be either true or false"
  default     = false
}

variable "multi_region_write" {
  type        = bool
  description = "Enable multiple write locations for this Cosmos DB account"
  default     = false
}

variable "backup_enabled" {
  type        = bool
  description = "Enable backup for this Cosmos DB account"
  default     = true
}

variable "backup_type" {
  type        = string
  description = "Type of backup - can be either Periodic or Continuous"
  default     = "periodic"
}

variable "backup_interval" {
  type        = string
  description = "The interval in minutes between two backups. This is configurable only when type is Periodic. Possible values are between 60 and 1440."
  default     = 60
}

variable "backup_retention" {
  type        = string
  description = "The time in hours that each backup is retained. This is configurable only when type is Periodic. Possible values are between 8 and 720."
  default     = 8
}

variable "backup_storage_redundancy" {
  type        = string
  description = "he storage redundancy which is used to indicate type of backup residency. This is configurable only when type is Periodic. Possible values are Geo, Local and Zone"
  default     = "Geo"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the existing key vault. It is needed for encryption using customer managed key."
  default     = ""
}

variable "key_vault_rg_name" {
  type        = string
  description = "Name of the resource group in which key vault exists."
  default     = ""
}

variable "akv_key_name" {
  type        = string
  description = "Name of the existing key in key vault. It is needed for encryption using customer managed key."
  default     = ""
}

variable "geo_locations" {
  description = "List of map of geo locations and other properties to create primary and secodanry databasees."
  type        = any
  default = [
    {
      geo_location      = "eastus"
      failover_priority = 0
      zone_redundant    = false
    },
  ]
}

variable "capabilities" {
  type        = map(any)
  description = "Map of non-sql DB API to enable support for API other than SQL"
  default = {
    sql       = "SQL"
    table     = "EnableTable"
    gremlin   = "EnableGremlin"
    mongo     = "EnableMongo"
    cassandra = "EnableCassandra"
  }
}

variable "additional_capabilities" {
  type        = list(string)
  description = "List of additional capabilities for Cosmos DB API. - possible options are DisableRateLimitingResponses, EnableAggregationPipeline, EnableServerless, mongoEnableDocLevelTTL, MongoDBv3.4, AllowSelfServeUpgradeToMongo36"
  default     = []
}

/*
  The following section contains networking parameters 
*/
variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access to cosmos db"
  default     = false
}

variable "ip_firewall_enabled" {
  type        = bool
  description = "Enable ip firewwall to allow connection to this cosmosdb from client's machine and from azure portal."
  default     = true
}

variable "firewall_ip" {
  type        = list(string)
  description = "List of ip address to allow access from the internet or on-premisis network."
  default     = []
}

variable "azure_portal_access" {
  type        = list(string)
  description = "List of ip address to enable the Allow access from the Azure portal behavior."
  default     = ["104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"]
}

variable "azure_dc_access" {
  type        = list(string)
  description = "List of ip address to enable the Accept connections from within public Azure datacenters behavior."
  default     = ["0.0.0.0"]
}

# Private endpoint variables 
variable "private_endpoint" {
  type = map(object({
    enabled                         = bool
    name                            = string
    vnet_rg_name                    = string
    vnet_name                       = string
    subnet_name                     = string
    dns_zone_rg_name                = string
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
