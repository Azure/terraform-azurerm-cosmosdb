/*
  The following section contains diagnostic logs parameters 
*/
variable "log_analytics" {
  type = map(object({
    la_workspace_name    = string
    la_workspace_rg_name = string
  }))
  description = "Log Analytics parameters for one or more log analytics workspace to send daignostic logs to log analytics workspace."
  default     = {}
}

variable "storage_account" {
  type = map(object({
    storage_account_name         = string
    storage_account_rg_name      = string
    enable_logs_retention_policy = bool
    logs_retention_days          = number
  }))
  description = "Storage account parameters for one or more storage account to send daignostic logs to storage account."
  default     = {}
}

variable "event_hub" {
  type = map(object({
    event_hub_name           = string
    event_hub_namespace_name = string
    event_hub_rg_name        = string
    event_hub_auth_rule_name = string
  }))
  description = "Event Hub parameters for one or more event hub to send daignostic logs to event hub."
  default     = {}
}

variable "logs_config" {
  type        = map(any)
  description = "Map of non-sql DB API logs configuration to enable logging for respective API"
  default = {
    sql       = "SQL"
    table     = "TableApiRequests"
    gremlin   = "GremlinRequests"
    mongo     = "MongoRequests"
    cassandra = "CassandraRequests"
  }
}