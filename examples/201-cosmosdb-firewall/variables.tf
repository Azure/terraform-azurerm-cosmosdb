variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public access"
  default     = false
}

variable "ip_firewall_enabled" {
  type        = bool
  description = "Enable IP firewall"
  default     = true
}

variable "firewall_ip" {
  type        = list(string)
  description = "List of ip address to allow access from the internet or on-premisis network."
  default     = ["13.65.25.19"]
}

variable "cosmos_account_name" {}
variable "cosmos_api" {}
variable "sql_dbs" {}
variable "sql_db_containers" {}