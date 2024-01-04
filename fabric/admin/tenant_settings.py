# Here's a sample Python script that can produce a report on Microsoft Fabric (previously called as Power BI) tenant settings using the REST API:
import requests
import pandas as pd

# Replace these values with your own
tenant_id = "your-tenant-id"
client_id = "your-client-id"
client_secret = "your-client-secret"
scope = "https://analysis.windows.net/powerbi/api/.default"
# Get an access token from Azure AD
token_url = f"https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token"
token_data = {
    "client_id": client_id,
    "client_secret": client_secret,
    "scope": scope,
    "grant_type": "client_credentials"
}
token_response = requests.post(token_url, data=token_data)
token = token_response.json()["access_token"]
# Call the Fabric REST API for tenant settings
fabric_url = "https://api.fabric.microsoft.com/v1/admin/tenantsettings"
fabric_headers = {
    "Authorization": f"Bearer {token}"
}
fabric_response = requests.get(fabric_url, headers=fabric_headers)
fabric_data = fabric_response.json()
# Convert JSON to DataFrame
df = pd.json_normalize(fabric_data.get('tenantSettings')) 
# Write the tenant settings report DataFrame to a CSV file
df.to_csv("tenant_settings_report.csv", index=False)
# Print the tenant settings report DataFrame
df
