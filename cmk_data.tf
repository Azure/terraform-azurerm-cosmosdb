# Customer managed key dependencies  
data "azurerm_key_vault" "this" {
  count               = var.key_vault_name != "" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

data "azurerm_key_vault_key" "this" {
  count        = var.key_vault_key_name != "" ? 1 : 0
  name         = var.key_vault_key_name
  key_vault_id = data.azurerm_key_vault.this[count.index].id
}