variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics Workspace Name"
}

variable "cosmos_account_name" {}
variable "cosmos_api" {}
variable "sql_dbs" {}
variable "sql_db_containers" {}