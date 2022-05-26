resource "azurerm_cosmosdb_sql_database" "this" {
  for_each            = var.sql_dbs
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

resource "azurerm_cosmosdb_sql_container" "this" {
  for_each               = var.sql_db_containers
  name                   = each.value.container_name
  resource_group_name    = data.azurerm_resource_group.this.name
  account_name           = azurerm_cosmosdb_account.this.name
  database_name          = each.value.db_name
  partition_key_path     = each.value.partition_key_path
  partition_key_version  = each.value.partition_key_version != null ? each.value.partition_key_version : 2
  throughput             = each.value.container_max_throughput != null ? null : each.value.container_throughout
  default_ttl            = each.value.default_ttl != null ? each.value.default_ttl : null
  analytical_storage_ttl = each.value.analytical_storage_ttl != null ? each.value.analytical_storage_ttl : null

  # Autoscaling is optional and depends on max throughput parameter. Mutually exclusive vs. throughput. 
  dynamic "autoscale_settings" {
    for_each = each.value.container_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.container_max_throughput
    }
  }

  # Indexing policy is optional
  dynamic "indexing_policy" {
    for_each = length(each.value.indexing_policy_settings) > 0 ? [1] : []
    content {
      # Indexing mode is optional 
      indexing_mode = each.value.indexing_policy_settings.sql_indexing_mode != null ? each.value.indexing_policy_settings.sql_indexing_mode : null

      # Included path is optional
      dynamic "included_path" {
        for_each = each.value.indexing_policy_settings.sql_included_path != null ? [1] : []
        content {
          path = each.value.indexing_policy_settings.sql_included_path
        }
      }
      # Excluded path is optional 
      dynamic "excluded_path" {
        for_each = each.value.indexing_policy_settings.sql_excluded_path != null ? [1] : []
        content {
          path = each.value.indexing_policy_settings.sql_excluded_path
        }
      }
      # Composite Index is optional
      dynamic "composite_index" {
        for_each = each.value.indexing_policy_settings.composite_indexes != null ? each.value.indexing_policy_settings.composite_indexes : {}
        content {
          dynamic "index" {
            for_each = composite_index.value.indexes
            content {
              path  = index.value.path
              order = index.value.order
            }
          }
        }
      }
      # Spatial Index is optional 
      dynamic "spatial_index" {
        for_each = each.value.indexing_policy_settings.spatial_indexes != null ? each.value.indexing_policy_settings.spatial_indexes : {}
        content {
          path = spatial_index.value.path
        }
      }
    }
  }
  dynamic "unique_key" {
    for_each = length(each.value.sql_unique_key) > 0 ? each.value.sql_unique_key : []
    content {
      paths = each.value.sql_unique_key
    }
  }
  # Confliction resolution policy 
  dynamic "conflict_resolution_policy" {
    for_each = each.value.conflict_resolution_policy != null ? [1] : []
    content {
      mode                          = each.value.conflict_resolution_policy.mode
      conflict_resolution_path      = each.value.conflict_resolution_policy.mode == "LastWriterWins" ? each.value.conflict_resolution_policy.path : null
      conflict_resolution_procedure = each.value.conflict_resolution_policy.mode == "Custom" ? each.value.conflict_resolution_policy.procedure : null
    }
  }

  # Depends on existence of Cosmos DB SQL API Database managed by module
  depends_on = [
    azurerm_cosmosdb_sql_database.this
  ]
}