# Getting Started
The following cosmos db module provides configurable baseline service capabilities to help simplify infrastructure as code deployment and accelerate workload enablement. The module is separate into relevant resource groupings based on cosmos db database/api requirements. The input variables specified for the module will provision the appropriate database/api instances. This module does not create dependent resources for certain configurations (ex. the module will not create a key vault for customer managed key encryption, this should be created external to the module and passed in as a parameter).

Note: Please specify only the required database/api parameter for single api type. Specifying multiple (sql_api parameters and mongo_db parameters) would result in unintended errors. 

# Terraform Files and associated resources, variables and outputs
- main.tf: Azure Cosmos DB account and related configurations across all apis
    - IP Firewall and Private Endpoint configurations 
    - Custoemr managed key for encryption 
    - AAD Identity configuration 
- sql_api.tf: SQL API resources 
- mongo_api.tf: Mongo API resources
- cassandra_api.tf: Cassandra API resources
- gremlin_api.tf: Gremlin API resources 
- variables.tf: Variable inputs for cosmos db resources to provision
- outputs.tf: Output attributes for all cosmos db resources 

# Contribute 
This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the Microsoft Open Source Code of Conduct. For more information see the Code of Conduct FAQ or contact opencode@microsoft.com with any additional questions or comments.
