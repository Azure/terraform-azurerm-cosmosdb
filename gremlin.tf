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
  partition_key_version = each.value.partition_key_version != null ? each.value.partition_key_version : null
  default_ttl           = each.value.default_ttl_seconds != null ? each.value.default_ttl_seconds : null
  throughput            = each.value.graph_max_throughput != null ? null : each.value.graph_throughput

  dynamic "autoscale_settings" {
    for_each = each.value.graph_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.graph_max_throughput
    }
  }
  # Index policy is required
  dynamic "index_policy" {
    for_each = length(each.value.index_policy_settings) > 0 ? [1] : []
    content {
      # Automatic indexing policy is optional
      automatic = each.value.index_policy_settings.indexing_automatic != null ? each.value.index_policy_settings.indexing_automatic : null
      # Indexing mode is required
      indexing_mode = each.value.index_policy_settings.indexing_mode
      # Included paths is optional 
      included_paths = each.value.index_policy_settings.included_paths != null ? each.value.index_policy_settings.included_paths : null
      # Excluded paths is optional 
      excluded_paths = each.value.index_policy_settings.excluded_paths != null ? each.value.index_policy_settings.excluded_paths : null

      # Composite index is optional 
      dynamic "composite_index" {
        for_each = each.value.index_policy_settings.composite_indexes != null ? each.value.index_policy_settings.composite_indexes : {}
        content {
          dynamic "index" {
            for_each = composite_index.value.indexes
            content {
              path  = index.value.index_path
              order = index.value.index_order
            }
          }
        }
      }
      # Spatial Index is optional 
      dynamic "spatial_index" {
        for_each = each.value.index_policy_settings.spatial_indexes != null ? each.value.index_policy_settings.spatial_indexes : {}
        content {
          path = spatial_index.value.spatial_index_path
        }
      }
    }
  }

  # Unique Key is optional 
  unique_key {
    paths = each.value.unique_key
  }

  # Conflict Resolution policy is optional
  dynamic "conflict_resolution_policy" {
    for_each = each.value.conflict_resolution_policy != null ? [1] : []
    content {
      mode                          = each.value.conflict_resolution_policy.conflict_resolution_mode
      conflict_resolution_path      = each.value.conflict_resolution_policy.conflict_resolution_mode == "LastWriterWins" ? each.value.conflict_resolution_policy.conflict_resolution_path : null
      conflict_resolution_procedure = each.value.conflict_resolution_policy.conflict_resolution_mode == "Custom" ? each.value.conflict_resolution_policy.conflict_resolution_procedure : null
    }
  }

  # Depends on existence of Cosmos DB Gremlin API Database managed by module
  depends_on = [
    azurerm_cosmosdb_gremlin_database.this
  ]

}