resource_group_name = "rg-sample-202"
location            = "eastus"
cosmos_account_name = "samplecosmosacct202"
cosmos_api          = "sql"
sql_dbs = {
  one = {
    db_name           = "dbnoautoscale"
    db_throughput     = 400
    db_max_throughput = null
  },
  two = {
    db_name           = "dbautoscale"
    db_throughput     = null
    db_max_throughput = 1000
  }
}
sql_db_containers = {
  one = {
    container_name           = "container1"
    db_name                  = "dbnoautoscale"
    partition_key_path       = "/container/id"
    partition_key_version    = 2
    container_throughout     = 400
    container_max_throughput = null
    default_ttl = null 
    analytical_storage_ttl = null 
    indexing_policy_settings = {
      sql_indexing_mode = "consistent"
      sql_included_path = "/*"
      sql_excluded_path = null
      composite_indexes = {
        compositeindexone = {
          indexes = [
            {
              path  = "/container/name"
              order = "Ascending"
            },
            {
              path  = "/container/id"
              order = "Ascending"
            }
          ]
        }
      }
      spatial_indexes = {
        spatialindexone = {
          path = "/*"
        }
      }
    }
    sql_unique_key = ["/container/id"]
    conflict_resolution_policy = null 
  }
  two = {
    container_name           = "container1"
    db_name                  = "dbautoscale"
    partition_key_path       = "/container/id"
    partition_key_version    = 2
    container_throughout     = 500
    container_max_throughput = null
    default_ttl = null 
    analytical_storage_ttl = null 
    indexing_policy_settings = {
      sql_indexing_mode = "consistent"
      sql_included_path = "/*"
      sql_excluded_path = "/excluded/?"
      composite_indexes = {}
      spatial_indexes   = {}
    }
    sql_unique_key = ["/container/id"]
    conflict_resolution_policy = null 
  }
}

# Virtual Network, Subnet, DNS Zone and PE Parameters 
virtual_network_name       = "samplevnet_202"
vnet_address_space         = ["10.0.0.0/16"]
subnet_name                = "samplesubnet_202"
subnet_prefixes            = ["10.0.0.0/24"]
private_dns_vnet_link_name = "sqlapi_zone_link"
dns_zone_group_name        = "pe_zone_group"
pe_name                    = "cosmosdb_pe"
pe_connection_name         = "cosmosdb_pe_connection"