# Get Power BI Datasets and it's Data Source Connection Details from REST API

# PowerShell
param (  
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
$OutputRootFolder = "C:\temp\PowerBI\DataSources"
$PBIDatasetsReportFilePath = $OutputRootFolder+"\PowerBI_DataSources_Report_$(Get-Date -Format 'yyyy-MM-dd').csv"

#Create output directory if it doesn't exist
if (!(Test-Path $OutputRootFolder)){
    New-Item -ItemType directory -Path $OutputRootFolder
}

#oAuth login URL & payload
$loginURL = "https://login.microsoftonline.com"
$resource = "https://analysis.windows.net/powerbi/api"
$pbiDatasetsAPI = "https://api.powerbi.com/v1.0/myorg/admin/datasets"
$contentType="application/json"

#### STEP 1 get auth token
$auth_body = @{grant_type="client_credentials";resource=$resource;client_id=$ClientID;client_secret=$ClientSecret;scope="openid";client_info=1}
$oauth = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantId/oauth2/token?api-version=1.0 -Body $auth_body
$headerParams = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}

#### STEP 2 Invoke dataset API to get list of datasets
$allDatasets = Invoke-RestMethod -Headers $headerParams -method Get -Uri ($pbiDatasetsAPI) -contentType $contentType -Verbose

#### STEP 3 Read datasets info 
$datasetslist = New-Object System.Collections.ArrayList
foreach ($dset in $allDatasets.value) 
{ 
    $dsetInfo = ""| select  "Dataset Id","Dataset Name","Dataset Url","Configured By","Created Date","Content Provider Type","Target Storage Mode","Workspace Id", "Connection Details", "Datasource Type", "Datasource Id", "Gateway Id"
    $dsetInfo."Dataset Id" = $dset.id
    $dsetInfo."Dataset Name" = $dset.name
    $dsetInfo."Dataset Url" = $dset.webUrl
    $dsetInfo."Configured By" = $dset.configuredBy
    $dsetInfo."Created Date" = $dset.createdDate
    $dsetInfo."Content Provider Type" = $dset.contentProviderType
    $dsetInfo."Target Storage Mode" = $dset.targetStorageMode
    $dsetInfo."Workspace Id" = $dset.workspaceId

    $datasetId = $dset.id
    $pbiDataSourceAPI ="https://api.powerbi.com/v1.0/myorg/admin/datasets/$datasetId/datasources"
    $pbiDataSourceAPI

    sleep(30)
    
    #### STEP 4 Invoke datasource API to get list of datasources for the dataset
    $allDataSources = Invoke-RestMethod -Headers $headerParams -method Get -Uri ($pbiDataSourceAPI) -contentType $contentType -Verbose
    
    foreach($dsrc in $allDataSources.value)
    {
        ### STEP 5 output the datasets list to csv file
        #$datasourceId = $dsrc.datasourceId
        #$allDataSources.value | ConvertTo-Json -Depth 100 | Out-File "$OutputRootFolder\all\$datasourceId.json"

        $dsetInfo."Connection String" = $dsrc.connectionDetails
        $dsetInfo."Datasource Type" = $dsrc.datasourceType
        $dsetInfo."Datasource Id" = $dsrc.datasourceId
        $dsetInfo."Gateway Id" = $dsrc.gatewayId
        [void]$datasetslist.Add($dsetInfo)
    }

}  

### STEP 5 output the datasets list to csv file
if($datasetslist.Count -gt 0){
    $datasetslist|Export-Csv -Path $PBIDatasetsReportFilePath -NoTypeInformation
    Write-Host "Saved PBI Datasets report" -ForegroundColor Green
}
