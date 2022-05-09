# Getting Started
The following cosmos db terraform module provides configurable baseline service capabilities to help simplify infrastructure as code deployment and accelerate workload enablement. The module is separate into relevant subresource groupings based on cosmos db api requirements. The input variables specified for the module will provision the appropriate database/api instances. This module does not create dependent resources for certain configurations, these resources should be provision external to the module. Ex. the module will not create a key vault for customer managed key encryption, this should be created external to the module and passed in as a parameter. Please see the examples for different configurations.

Important: Please specify only the required database/api parameter for single api type. Specifying multiple (sql_api parameters and mongo_db parameters) would result in unintended errors. 

# Terraform Files and associated resources, variables and outputs
- Azure Cosmos DB Account Creation and Configurations
    - Azure Cosmos DB Account
        - main.tf and variables.tf helps create the cosmos db account and is the main portion of the module
    - Networking
        - firewall_variables.tf and locals.tf are used to aggregrated list of IPs/VNETs to whitelist within cosmos db account
        - privateendpoint.tf supports creation of multiple private endpoints and assumes that there are some network perms available to create the endpoints
    - Customer managed key 
        - cmk_data.tf and cmk_variables.tf c
    - Diagnostic settings
        - diagnostic.tf (Supports event hub, storage account and log analytics workspace targets)
- DBs by API
    - sql_api.tf and sql_variables.tf: SQL API resources 
    - mongo_api.tf and mongo_variables.tf: Mongo API resources
    - cassandra_api.tf and cassandra_variable.tf: Cassandra API resources
    - gremlin_api.tf and gremlin_variables.tf: Gremlin API resources 
    - table.tf and table_variables.tf: Table API resources 
- Outputs 
    - account_output.tf and apis_output.tf: Contains outputs for relevant 

# Feedback and suggestions
Please create a github issue for suggestions, feedback and questions.

# Contribute 
This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the Microsoft Open Source Code of Conduct. For more information see the Code of Conduct FAQ or contact opencode@microsoft.com with any additional questions or comments.

