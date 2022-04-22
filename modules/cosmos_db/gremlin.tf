resource "azurerm_cosmosdb_gremlin_database" "this" {
  for_each            = var.gremlin_dbs
  name                = each.value.db_name
  resource_group_name = data.azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = each.value.db_max_throughput != null ? null : each.value.db_throughput

  dynamic "autoscale_settings" {
    for_each = each.value.db_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.db_max_throughput
    }
  }
}

resource "azurerm_cosmosdb_gremlin_graph" "this" {
  for_each              = var.gremlin_graphs
  name                  = each.value.graph_name
  resource_group_name   = data.azurerm_resource_group.this.name
  account_name          = azurerm_cosmosdb_account.this.name
  database_name         = each.value.db_name
  partition_key_path    = each.value.partition_key_path
  partition_key_version = each.value.partition_key_version != null ? each.value.partition_key_version : 2
  default_ttl           = each.value.default_ttl_seconds != null ? each.value.default_ttl_seconds : "-1"
  throughput            = each.value.graph_max_throughput != null ? null : each.value.graph_throughput

  dynamic "autoscale_settings" {
    for_each = each.value.graph_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.graph_max_throughput
    }
  }
  # Index policy is required
  index_policy {
    automatic      = each.value.gremlin_automatic_indexing_policy
    indexing_mode  = each.value.gremlin_indexing_mode
    included_paths = each.value.gremlin_included_paths
    excluded_paths = each.value.gremlin_excluded_paths
  }

  # Conflict Resolution policy is optional
  dynamic "conflict_resolution_policy" {
    for_each = each.value.gremlin_conflict_resolution_mode != null ? [1] : []
    content {
      mode                     = each.value.gremlin_conflict_resolution_mode
      conflict_resolution_path = each.value.conflict_resolution_path != null ? each.value.conflict_resolution_path : null
    }
  }

  # Unique key is optional
  dynamic "unique_key" {
    for_each = each.value.gremlin_unique_key != null ? [1] : []
    content {
      paths = each.value.gremlin_unique_key
    }
  }

  # Depends on existence of Cosmos DB Gremlin API Database managed by module
  depends_on = [
    azurerm_cosmosdb_gremlin_database.this
  ]

}