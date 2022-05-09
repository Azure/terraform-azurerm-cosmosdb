/*
  The following section contains firewall parameters 
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