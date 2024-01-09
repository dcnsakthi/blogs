Microsoft Fabric is a unified platform that combines data and services, encompassing data science, data engineering, data lakehouses, data warehouses and visualizations, to enhance your team’s data utilization. Discover how to leverage Fabric’s features like OneLake, Data Factory, Synapse, Data Activator, Power BI, and Microsoft Purview to usher your data into the AI era.

Tenant settings provide a detailed level of control over the features accessible to your organization. If you’re worried about sensitive data, some features may not be suitable for your organization, or you may want to limit certain features to specific groups.

While tenant settings that govern the availability of features in the Power BI user interface can aid in setting up governance policies, they do not serve as a security measure. For instance, the ‘Export data’ setting does not limit a Power BI user’s permissions on a semantic model. Power BI users with read access to a semantic model have the right to query this model and may be able to save the results without utilizing the ‘Export data’ feature in the Power BI user interface.

By extracting and externally visualizing tenant settings in Power BI reports, stakeholders can view, archive, and compare these settings with historical data. This approach negates the need for higher privileges and access to the Microsoft Fabric (previously Power BI) admin portal.

To generate a tenant settings report using REST API, you can use the following steps:
- Obtain an access token from Microsoft Entra (aka Azure Active Directory) by following this guide:
    https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow
- Use the access token to call the Fabric REST API endpoint for tenant settings:
    https://learn.microsoft.com/rest/api/fabric/admin/tenants/get-tenant-settings
- Parse the JSON response and extract the relevant information for your report.

## Tenant Settings Snapshot Comparison
Save the API response as JSON files every day or week and use Power BI to contrast each snapshot files, which also lets you subscribe to an email or alerts based on the metrics if any.

[Code Segment](https://github.com/dcnsakthi/blogs/blob/main/fabric/admin/snapshot_tenant_settings.pqx)

<img width="1041" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/364254cf-3953-4cf0-9936-c047a886309a">


Here are example scripts in M query, Python and PowerShell that can generate a report on tenant settings for Microsoft Fabric (including Power BI) using the REST API:

## Power BI M Query
[Code Segment](https://github.com/dcnsakthi/blogs/blob/main/fabric/admin/tenant_settings.pqx)

<img width="902" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/7de8916c-e785-4a71-9e4f-ab8d232f7044">


## Python
[Code Segment](https://github.com/dcnsakthi/blogs/blob/main/fabric/admin/tenant_settings.py)

<img width="880" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/66cfbbc6-46e6-4540-975c-71b6cd9eec3f">



## PowerShell
[Code Segment](https://github.com/dcnsakthi/blogs/blob/main/fabric/admin/tenant_settings.ps1)

<img width="1119" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/964f1a69-6a87-4e70-ba43-10b9b941e7ef">

