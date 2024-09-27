// Databricks Notebooks Connecting with Microsoft Fabric OneLake

// Step #1: Create a Service Principal in Microsoft Entra ID (Azure Active Directory) - To get started, create a Service Principal in Microsoft Entra ID (Azure Active Directory) with the required credentials, ensuring that Microsoft Fabric OneLake is present in the same tenant.
// Step #2: Grant Permission to the Service Principal - Next, grant the appropriate permission to the Service Principal within the Microsoft Fabric workspace, allowing it to read data from the OneLake storage effectively.
// Step #3: Create Notebooks in Databricks - Utilize Databricks notebooks to read data from the Microsoft Fabric OneLake Lakehouse endpoint using Spark compute. These notebooks should include the Service Principal credentials (Tenant ID, Client ID, Client Secret) to establish secure access to the OneLake data.

%scala
// Configure the Service Principal credentials
spark.conf.set("fs.azure.account.auth.type.onelake.dfs.fabric.microsoft.com", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.onelake.dfs.fabric.microsoft.com", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.onelake.dfs.fabric.microsoft.com", {***clientId***})
spark.conf.set("fs.azure.account.oauth2.client.secret.onelake.dfs.fabric.microsoft.com", {***clientSecret***})
spark.conf.set("fs.azure.account.oauth2.client.endpoint.onelake.dfs.fabric.microsoft.com", s"https://login.microsoftonline.com/{***$tenantId***}/oauth2/token")

// Read the data from Microsoft Fabric
val df = spark.read.format("delta")
  .option("header", "true")
  .option("inferSchema", "true")
  .load("abfss://{***WorkspaceName***}@onelake.dfs.fabric.microsoft.com/{***LakehoueName***}.Lakehouse/Tables/{***SchemaName***}/{***TableName***}")

// Display the DataFrame
display(df)
