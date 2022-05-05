# Azure provider version 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.84"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}

resource "azurerm_cosmosdb_account" "this" {
  name                          = local.cosmos_account_name
  location                      = local.location
  resource_group_name           = data.azurerm_resource_group.this.name
  offer_type                    = "Standard"
  kind                          = var.cosmos_api == "mongo" ? "MongoDB" : "GlobalDocumentDB"
  public_network_access_enabled = var.public_network_access_enabled
  ip_range_filter               = var.ip_firewall_enabled == true ? local.firewall_ips : null

  enable_automatic_failover       = var.auto_failover
  enable_free_tier                = var.free_tier
  enable_multiple_write_locations = var.multi_region_write
  key_vault_key_id                = var.key_vault_name != "" ? data.azurerm_key_vault_key.this[0].versionless_id : null

  tags = local.tags

  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }

  dynamic "capabilities" {
    for_each = var.cosmos_api == "sql" ? [] : [1]
    content {
      name = var.capabilities[var.cosmos_api]
    }
  }

  dynamic "capabilities" {
    for_each = var.additional_capabilities != null ? var.additional_capabilities : []
    content {
      name = capabilities.value
    }
  }

  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value["geo_location"]
      failover_priority = geo_location.value["failover_priority"]
      zone_redundant    = geo_location.value["zone_redundant"]
    }
  }

  dynamic "backup" {
    for_each = var.backup_enabled == true ? [1] : []
    content {
      type                = title(var.backup_type)
      interval_in_minutes = lower(var.backup_type) == "periodic" ? var.backup_interval : ""
      retention_in_hours  = lower(var.backup_type) == "periodic" ? var.backup_retention : ""
    }
  }

  dynamic "analytical_storage" {
    for_each = var.analytical_storage.enabled ? [1] : []
    content {
      schema_type = var.analytical_storage.schema_type
    }
  }

  dynamic "identity" {
    for_each = var.enable_systemassigned_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}