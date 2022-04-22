# Introduction 
The following repository contains a cosmos db module and samples that end-users can leverage and deploy. The repo is structured as follows: 
1. Modules 
    1. Cosmos db 
2. samples 
    - 101-cosmosdb-sql-api 
        - Cosmos DB SQL API with the module 
    - 102-cosmosdb-mongo-api
        - Cosmos DB Mongo API with the module
    - 103-cosmosdb-cassandra-api
        - Cosmos DB Cassandra API with the module
    - 104-cosmosdb-gremlin-api
        - Cosmos DB Gremlin API with the module
    - 105-cosmosdb-table-api
        - Cosmos DB Table API with the module
    - 201-cosmosdb-firewall
        - Cosmos DB with IP firewall enabled - IP of terraform client caller (end-user/ado-agent)
    - 202-cosmosdb-private-endpoint
        - Cosmos DB with private endpoint 
    - 203-cosmosdb-customer-managed-key
        - Cosmos DB encrypted with customer managed key 
    - 204-cosmosdb-managed-identity
        - Cosmos DB with first-party identity enabled or user assigned identity
    - 205-cosmosdb-diagnostics-settings
        - Cosmos DB with diagnostic settings enabled for log analytics
    - 301-cosmosdb-multi-region-write
        - Cosmos DB SQL API with multi-master write 
    - 302-cosmosdb-with-read-replicas
        - Cosmos DB SQL API with single region write, multi-region read 
    - 303-secured-cosmosdb
        - Cosmos DB SQL API with private endpoint, CMK, managed identity and single region write, multi-region read 
    - 304-cosmosdb-private-endpoint-with-aks
        - Cosmos DB SQL API with privat endpoint and customer managed key
        - VNET with 2 subnets, Public Subnet with AKS, Private Subnet for Cosmos DB Private Endpoint 
        - AKS public cluster with public IP ingress via ELB
        - Helm deploy of voting app into AKS 