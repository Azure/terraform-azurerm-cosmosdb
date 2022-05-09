variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault."
  default     = "standard"
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU for Key Vault. Possible values are standard and premium"
  default     = "standard"
}

variable "key_vault_key_name" {
  type        = string
  description = "Name of the Key which is going to be created and used for encrytpion."
  default     = "standard"
}

variable "cosmos_account_name" {}
variable "cosmos_api" {}
variable "sql_dbs" {}
variable "sql_db_containers" {}