data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# Acessing AzureRM provider configuration
data "azurerm_client_config" "current" {
}

# Diagnostic logs dependencies for LA workspace
data "azurerm_log_analytics_workspace" "this" {
  for_each            = length(var.log_analytics) > 0 ? var.log_analytics : {}
  name                = each.value.la_workspace_name
  resource_group_name = each.value.la_workspace_rg_name
}

# Diagnostic logs dependencies for Storage account
data "azurerm_storage_account" "this" {
  for_each            = length(var.storage_account) > 0 ? var.storage_account : {}
  name                = each.value.storage_account_name
  resource_group_name = each.value.storage_account_rg_name
}

# Diagnostic logs dependencies for Event Hub Authorization Rule
data "azurerm_eventhub_authorization_rule" "this" {
  for_each            = length(var.event_hub) > 0 ? var.event_hub : {}
  name                = each.value.event_hub_rule_name
  namespace_name      = each.value.event_hub_namespace_name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = each.value.eventhub_rg_name
}

# Customer managed key dependencies  
data "azurerm_key_vault" "this" {
  count               = var.key_vault_name != "" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

data "azurerm_key_vault_key" "this" {
  count        = var.akv_key_name != "" ? 1 : 0
  name         = var.akv_key_name
  key_vault_id = data.azurerm_key_vault.this[count.index].id
}