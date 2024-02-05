# Sample Script: Export Microsoft Fabric Tenant Settings to SharePoint Using Service Principal in PowerShell
param (  

        #Tenant Id
        [Parameter(Mandatory=$false)]
        $tenantId = "<your-tenant-id>",
        #Azure registered AD application client ID
        [Parameter(Mandatory=$false)]
        $clientId = "<your-client-id>",
        #Secret of the Azure registered application
        [Parameter(Mandatory=$false)]
        $clientSecret ="<your-client-secret>",
        #Tenant Name
        [Parameter(Mandatory=$false)]
        $tenantName = "<your-tenant-name>.onmicrosoft.com",
        #SharePoint Online Team Site
        [Parameter(Mandatory=$false)]
        $spTeamSiteUrl = "https://<your-sharepoint-site>.sharepoint.com/sites/<your-teamsite-name>",
        #SharePoint Team Site Folder Path
        [Parameter(Mandatory=$false)]
        $spFolderPath = "Shared Documents/<your-sharepoint-export-path>",
        #SharePoint Team Site Certificate Path
        [Parameter(Mandatory=$false)]
        $authCertPath ="<your-authcert-path>SPOpnp.pfx"
)
#Output folder path
$tenantSettingsName = "MicrosoftFabric_TenantSettings_Report_$(Get-Date -Format 'yyyy-MM-dd').json"
# Connect to your SharePoint Online site
Connect-PnPOnline -CertificatePath $authCertPath -Tenant $tenantName -ClientId $clientId -Url $spTeamSiteUrl -WarningAction Ignore
#oAuth login URL & payload
$loginURL = "https://login.microsoftonline.com"
$resource = "https://analysis.windows.net/powerbi/api"
$tenantAdminAPI = "https://api.fabric.microsoft.com/v1/admin/tenantsettings"
$contentType="application/json"
#### STEP 1 get auth token
$auth_body = @{grant_type="client_credentials";resource=$resource;client_id=$clientId;client_secret=$clientSecret;scope="openid";client_info=1}
$oauth = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantId/oauth2/token?api-version=1.0 -Body $auth_body
$headerParams = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}
#### STEP 2 Invoke Microsoft Fabric Web API to get Tenant Settings list
$allSettings = Invoke-RestMethod -Headers $headerParams -method Get -Uri ($tenantAdminAPI) -contentType $contentType -Verbose
#### STEP 3 output the tenantSetting to json file
if($allSettings.tenantSettings.Count -gt 0){
    $currSettings = $allSettings.tenantSettings | ConvertTo-Json -Depth 100
    # Use the Add-PnPFile cmdlet to add the JSON content to a file in SharePoint
    $stream = [System.IO.MemoryStream]::new()
    $writer = [System.IO.StreamWriter]::new($stream)
    $writer.Write($currSettings)
    $writer.Flush()
    $stream.Position = 0
    # Save the JSON output to a SharePoint file
    Add-PnPFile -FileName $tenantSettingsName -Folder $spFolderPath -Stream $stream
    $writer.Close()
    $stream.Close()
    Write-Host "Saved Microsoft Fabric TenantSettings Report" -ForegroundColor Green
}

# References:
   # https://github.com/pnp/PnP-PowerShell/tree/master/Samples/SharePoint.ConnectUsingAppPermissions
   # https://pnp.github.io/powershell/cmdlets/Connect-PnPOnline.html
