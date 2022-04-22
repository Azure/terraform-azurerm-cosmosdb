resource "azurerm_cosmosdb_cassandra_keyspace" "this" {
  for_each            = var.cassandra_keyspaces
  name                = each.value.keyspace_name
  resource_group_name = data.azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = each.value.keyspace_max_throughput != null ? null : each.value.keyspace_throughput

  dynamic "autoscale_settings" {
    for_each = each.value.keyspace_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.keyspace_max_throughput
    }
  }
}

resource "azurerm_cosmosdb_cassandra_table" "this" {
  for_each              = var.cassandra_tables
  name                  = each.value.table_name
  cassandra_keyspace_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.this.name}/providers/Microsoft.DocumentDB/databaseAccounts/${azurerm_cosmosdb_account.this.name}/cassandraKeyspaces/${each.value.keyspace_name}"
  throughput            = each.value.table_max_throughput != null ? null : each.value.table_throughout
  default_ttl           = each.value.default_ttl_seconds != null ? each.value.default_ttl_seconds : "-1"

  dynamic "autoscale_settings" {
    for_each = each.value.table_max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.table_max_throughput
    }
  }

  # Schema is required. 
  schema {
    # column is required. 
    dynamic "column" {
      for_each = length(each.value.cassandra_schema_settings) > 0 ? [1] : []
      content {
        name = each.value.cassandra_schema_settings.column_key_name
        type = each.value.cassandra_schema_settings.column_key_type
      }
    }

    # partition_key is required. 
    dynamic "partition_key" {
      for_each = length(each.value.cassandra_schema_settings.partition_key_name) > 0 ? [1] : []
      content {
        name = each.value.cassandra_schema_settings.partition_key_name
      }
    }

    # cluster_key is otional. 
    dynamic "cluster_key" {
      for_each = each.value.cassandra_schema_settings.cluster_key_name != null ? [1] : []
      content {
        name     = each.value.cassandra_schema_cluster_key.cluster_key_name
        order_by = each.value.cassandra_schema_cluster_key.cluster_key_order_by
      }
    }
  }
  # Depends on existence of Cosmos DB Cassandra API Keyspace managed by module
  depends_on = [
    azurerm_cosmosdb_cassandra_keyspace.this
  ]
}