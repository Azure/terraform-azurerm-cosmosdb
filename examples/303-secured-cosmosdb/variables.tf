variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "resource_group_name_read_replica" {
  type        = string
  description = "Read Replica Resource Group Name"
}

variable "location_read_replica" {
  type        = string
  description = "Read Replica Azure Region"
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

variable "virtual_network_name" {
  type        = string
  description = "Virtual Network Name"
  default     = "samplevnet_303"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNET Address Prefixes"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "VNET Subnet Name"
  default     = "pe_subnet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Subnet Address Prefixes"
  default     = ["10.0.0.0/24"]
}

variable "private_dns_vnet_link_name" {
  type        = string
  description = "Private DNS Zone Link Name"
  default     = "sqlapi_zone_link"
}

variable "dns_zone_group_name" {
  type        = string
  description = "Zone Group Name for PE"
  default     = "pe_zone_group"
}

variable "pe_name" {
  type        = string
  description = "Private Endpoint Name"
  default     = "cosmosdb_pe"
}

variable "pe_connection_name" {
  type        = string
  description = "Private Endpoint Connection Name"
  default     = "pe_connection"
}

variable "virtual_network_name_read_replica" {
  type        = string
  description = "Virtual Network Name for read replica"
  default     = "samplevnet_rr_303"
}

variable "vnet_address_space_read_replica" {
  type        = list(string)
  description = "VNET Address Prefixes for read replica"
  default     = ["11.0.0.0/16"]
}

variable "subnet_name_read_replica" {
  type        = string
  description = "VNET Subnet Name for read replica"
  default     = "pe_rr_subnet"
}

variable "subnet_prefixes_read_replica" {
  type        = list(string)
  description = "Subnet Address Prefixes for read replica"
  default     = ["11.0.0.0/24"]
}

variable "private_dns_vnet_link_name_read_replica" {
  type        = string
  description = "Private DNS Zone Link Name for read replica"
  default     = "sqlapi_rr_zone_link"
}

variable "dns_zone_group_name_read_replica" {
  type        = string
  description = "Zone Group Name for PE for read replica"
  default     = "pe_rr_zone_group"
}

variable "pe_name_read_replica" {
  type        = string
  description = "Private Endpoint Name for read replica"
  default     = "cosmosdb_rr_pe"
}

variable "pe_connection_name_read_replica" {
  type        = string
  description = "Private Endpoint Connection Name for read replica"
  default     = "pe_rr_connection"
}


variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics Workspace Name"
}

variable "cosmos_account_name" {}
variable "cosmos_api" {}
variable "geo_locations" {}
variable "sql_dbs" {}
variable "sql_db_containers" {}
