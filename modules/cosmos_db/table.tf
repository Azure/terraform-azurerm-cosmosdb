resource "azurerm_cosmosdb_table" "this" {
  for_each            = var.tables
  name                = each.value.table_name
  resource_group_name = data.azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = each.value.table_max_throughput != null ? null : each.value.table_throughput

  dynamic "autoscale_settings" {
    for_each = each.value.table_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.table_max_throughput
    }
  }
}