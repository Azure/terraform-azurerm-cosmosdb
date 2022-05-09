variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "cosmos_account_name" {}
variable "cosmos_api" {}
variable "geo_locations" {}
variable "sql_dbs" {}
variable "sql_db_containers" {}