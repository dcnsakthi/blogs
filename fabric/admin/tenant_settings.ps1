# Here's a sample PowerShell script that can produce a report on Microsoft Fabric (previously called as Power BI) tenant settings using the REST API:
param (  
        #Specify if using full scan mode( default to incremental mode)
        $isFullScan = 0,
        #Tenant Id
        [Parameter(Mandatory=$false)]
        $tenantId = "your-tenant-id",
        #Azure registered AD application client ID
        [Parameter(Mandatory=$false)]
        $clientID     = "your-client-id",
        #Secret of the Azure registered application
        [Parameter(Mandatory=$false)]
        $clientSecret ="your-client-secret"
)

#Output folder path
$OutputRootFolder = "C:/temp/TenantSettings"
$FabricTenantSettingsReportFilePath = $OutputRootFolder+"\MicrosoftFabric_TenantSettings_Report_$(Get-Date -Format 'yyyy-MM-dd').json"

#Create output directory if it doesn't exist
if (!(Test-Path $OutputRootFolder)){
    New-Item -ItemType directory -Path $OutputRootFolder
}

#oAuth login URL & payload
$loginURL = "https://login.microsoftonline.com"
$resource = "https://analysis.windows.net/powerbi/api"
$tenantAdminAPI = "https://api.fabric.microsoft.com/v1/admin/tenantsettings"
$contentType="application/json"

#### STEP 1 get auth token
$auth_body = @{grant_type="client_credentials";resource=$resource;client_id=$ClientID;client_secret=$ClientSecret;scope="openid";client_info=1}
$oauth = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantId/oauth2/token?api-version=1.0 -Body $auth_body
$headerParams = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}

#### STEP 2 Invoke Microsoft Fabric Web API to get Tenant Settings list
$allSettings = Invoke-RestMethod -Headers $headerParams -method Get -Uri ($tenantAdminAPI) -contentType $contentType -Verbose

### STEP 3 output the tenantSetting to json file
if($allSettings.tenantSettings.Count -gt 0){
    $allSettings.tenantSettings | ConvertTo-Json -Depth 100 | Out-File $FabricTenantSettingsReportFilePath
    Write-Host "Saved Microsoft Fabric TenantSettings Report" -ForegroundColor Green
}
