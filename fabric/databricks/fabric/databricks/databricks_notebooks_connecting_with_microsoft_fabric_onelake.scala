%scala
// Configure the Service Principal credentials
spark.conf.set("fs.azure.account.auth.type.onelake.dfs.fabric.microsoft.com", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.onelake.dfs.fabric.microsoft.com", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.onelake.dfs.fabric.microsoft.com", clientId)
spark.conf.set("fs.azure.account.oauth2.client.secret.onelake.dfs.fabric.microsoft.com", clientSecret)
spark.conf.set("fs.azure.account.oauth2.client.endpoint.onelake.dfs.fabric.microsoft.com", s"https://login.microsoftonline.com/$tenantId/oauth2/token")

// Read the data from Microsoft Fabric
val df = spark.read.format("delta")
  .option("header", "true")
  .option("inferSchema", "true")
  .load("abfss://MSFabricWS@onelake.dfs.fabric.microsoft.com/EDLH.Lakehouse/Tables/dbo/publicholidays")

// Display the DataFrame
display(df)
