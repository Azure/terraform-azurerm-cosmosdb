# Private endpoint data dependencies 
# Subnet where PE will be created 
data "azurerm_subnet" "pe_subnet" {
  for_each             = var.private_endpoint
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_rg_name
}

# Resource group of the VNET-Subnet where PE will be created 
data "azurerm_resource_group" "pe_vnet_rg" {
  for_each = var.private_endpoint
  name     = each.value.vnet_rg_name
}

# Private DNS Zone where the A record for the PE will be inserted 
data "azurerm_private_dns_zone" "pe_private_dns_zone" {
  for_each            = var.private_endpoint
  name                = var.private_dns_zone_name[var.cosmos_api]
  resource_group_name = each.value.dns_zone_rg_name
}