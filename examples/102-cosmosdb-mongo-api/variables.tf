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
variable "mongo_dbs" {}
variable "mongo_db_collections" {}