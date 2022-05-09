resource "random_integer" "this" {
  min = 100000
  max = 999999
}

locals {
  cosmos_account_name  = var.cosmos_account_name != "" ? var.cosmos_account_name : "cosmos-${random_integer.this.result}"
  location             = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  ladiag_settings_name = "la-diag-${local.cosmos_account_name}"
  sadiag_settings_name = "sa-diag-${local.cosmos_account_name}"
  ehdiag_settings_name = "eh-diag-${local.cosmos_account_name}"
  firewall_ips         = var.firewall_ip == [] ? "${join(",", var.azure_portal_access, var.azure_dc_access)}" : "${join(",", var.firewall_ip, var.azure_portal_access, var.azure_dc_access)}"
  diag_settings_name   = "diag-${local.cosmos_account_name}"
  diag_logs            = var.cosmos_api == "sql" ? ["QueryRuntimeStatistics", "PartitionKeyRUConsumption"] : [var.logs_config[var.cosmos_api]]
  tags = {
    Application_Name = var.application_name
    Environment      = var.environment
  }
}
