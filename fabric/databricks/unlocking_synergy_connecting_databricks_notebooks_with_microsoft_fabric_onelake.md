# Unlocking Synergy: Connecting Databricks Notebooks with Microsoft Fabric OneLake

## Microsoft Fabric OneLake:

OneLake, an integral part of Microsoft Fabric, serves as a unified and logical data lake solution for your entire organization. Similar to OneDrive, OneLake is included by default with every Microsoft Fabric tenant and acts as a centralized repository for all your analytics data. By leveraging OneLake, customers can benefit from:
 - Consolidating data into a single, organization-wide data lake
 - Utilizing a single instance of data for analysis with multiple analytical engines

![image](https://github.com/dcnsakthi/blogs/assets/17950332/2fcbbd42-7f16-4758-a574-ffd1110986ac)

##  The Power of Integration:

By connecting Databricks notebooks with Microsoft Fabric OneLake's Lakehouse endpoints, organizations can benefit from the seamless integration and enhanced capabilities of both platforms. 

Connecting Microsoft Fabric OneLake Lakehouse endpoints with Databricks for Data Science and Data Engineering is a straightforward process for existing Databricks users. Follow these three simple steps to make this platform accessible:

### Step #1: Create a Service Principal in Microsoft Entra ID (Azure Active Directory)

To get started, create a Service Principal in Microsoft Entra ID (Azure Active Directory) with the required credentials, ensuring that Microsoft Fabric OneLake is present in the same tenant.

<img width="680" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/529b407c-346a-4260-921b-edc986d4147f">

### Step #2: Grant Permission to the Service Principal

Next, grant the appropriate permission to the Service Principal within the Microsoft Fabric workspace, allowing it to read data from the OneLake storage effectively.

<img width="1119" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/ba25b64a-126b-429c-9bda-daacbba6b109">

```
# OneLake Lakehouse Endpoints - Tables
abfss://{***WorkspaceName***}@onelake.dfs.fabric.microsoft.com/{**LakehoueName**}.Lakehouse/Tables/{****TableName****}

# OneLake Lakehouse Endpoints - Files
abfss://{***WorkspaceName***}@onelake.dfs.fabric.microsoft.com/{**LakehoueName**}.Lakehouse/Files/{****Folder/FileName****}
```

<img width="1118" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/722c55d5-d775-4d5c-b824-1081317a2dbe">

### Step #3: Create Notebooks in Databricks

Utilize Databricks notebooks to read data from the Microsoft Fabric OneLake Lakehouse endpoint using Spark compute. These notebooks should include the Service Principal credentials (Tenant ID, Client ID, Client Secret) to establish secure access to the OneLake data.

```
# Import the necessary libraries
from pyspark.sql import SparkSession

# Configure the Service Principal credentials
spark.conf.set("fs.azure.account.auth.type.onelake.dfs.fabric.microsoft.com", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.onelake.dfs.fabric.microsoft.com", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.onelake.dfs.fabric.microsoft.com", {*****clientId*****} )
spark.conf.set("fs.azure.account.oauth2.client.secret.onelake.dfs.fabric.microsoft.com", {*****clientSecret******} )
spark.conf.set("fs.azure.account.oauth2.client.endpoint.onelake.dfs.fabric.microsoft.com", "https://login.microsoftonline.com/"+{*****tenantId******}+"/oauth2/token")

# Create a Spark session
spark = SparkSession.builder \
    .appName("Read Data from Microsoft Fabric") \
    .getOrCreate()

# Read the data from Microsoft Fabric
df = spark.read.format("delta") \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .load("abfss://{***WorkspaceName***}@onelake.dfs.fabric.microsoft.com/{**LakehoueName**}.Lakehouse/Tables/{****TableName****}")

# Display the DataFrame
display(df)
```

<img width="955" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/c4f9b2eb-befb-4ddf-bfb8-93d8d56e099a">

The combination of Databricks notebooks and Microsoft Fabric OneLake's Lakehouse endpoints opens up new opportunities for organizations to harness the power of their data. By seamlessly integrating these platforms, businesses can streamline their analytics workflows, improve scalability and performance, simplify data management, and unlock real-time data insights. The integration empowers data teams to drive data-informed decisions and unlock the full potential of their data assets.
As organizations navigate the complexities of big data analytics and data engineering, the integration of Databricks notebooks with Microsoft Fabric OneLake is a game-changer. It propels businesses forward on their data-driven journeys, helping them stay competitive and innovative in today's data-centric world.

[Complete Script](https://github.com/dcnsakthi/blogs/blob/main/fabric/databricks/databricks_notebooks_connecting_with_microsoft_fabric_onelake.py)
