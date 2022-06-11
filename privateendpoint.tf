resource "azurerm_private_endpoint" "this" {
  for_each            = var.private_endpoint
  name                = each.value.name
  location            = data.azurerm_resource_group.pe_vnet_rg[each.key].location
  resource_group_name = data.azurerm_resource_group.pe_vnet_rg[each.key].name
  subnet_id           = data.azurerm_subnet.pe_subnet[each.key].id

  dynamic "private_dns_zone_group" {
    for_each = each.value.enable_private_dns_entry ? [1] : []
    content {
      name                 = each.value.dns_zone_group_name != "" ? each.value.dns_zone_group_name : "default"
      private_dns_zone_ids = [data.azurerm_private_dns_zone.pe_private_dns_zone[each.key].id]
    }
  }

  private_service_connection {
    name                           = each.value.private_service_connection_name != "" ? each.value.private_service_connection_name : "privateserviceconnection"
    private_connection_resource_id = azurerm_cosmosdb_account.this.id
    is_manual_connection           = each.value.is_manual_connection != "" ? each.value.is_manual_connection : false
    subresource_names              = [var.pe_subresource[var.cosmos_api]]
  }

  tags = local.tags
}