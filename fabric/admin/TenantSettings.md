Microsoft Fabric is a unified platform that integrates data and services, encompassing data science and data lakes, to enhance your team’s data utilization. Discover how to leverage Fabric’s features like OneLake, Data Factory, Synapse, Data Activator, Power BI, and Microsoft Purview to usher your data into the AI era.

To generate a tenant settings report using REST API, you can use the following steps:
- Obtain an access token from Microsoft Entra (aka Azure Active Directory) by following this guide:
    https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow
- Use the access token to call the Fabric REST API endpoint for tenant settings:
    https://learn.microsoft.com/rest/api/fabric/admin/tenants/get-tenant-settings
- Parse the JSON response and extract the relevant information for your report.

Here are example scripts in Python and PowerShell that can generate a report on tenant settings for Microsoft Fabric (including Power BI) using the REST API:

## Python
[Code Segment](https://github.com/dcnsakthi/blogs/blob/main/fabric/admin/tenant_settings.py)

<img width="880" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/66cfbbc6-46e6-4540-975c-71b6cd9eec3f">



## PowerShell
[Code Segment](https://github.com/dcnsakthi/blogs/blob/main/fabric/admin/tenant_settings.ps1)

<img width="1119" alt="image" src="https://github.com/dcnsakthi/blogs/assets/17950332/964f1a69-6a87-4e70-ba43-10b9b941e7ef">

