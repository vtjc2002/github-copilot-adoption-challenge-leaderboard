# App Registration setup script for Leaderboard App
# Creates an App Registration in Azure AD and updates the Web App configuration settings

param(
	[Parameter(Mandatory = $false)]
	[ValidateRange(1, 365)]
	[int]$passwordDaysToExpiration = 29
)

Write-Host "🚀 Creating App Registration for Leaderboard App" -ForegroundColor Green

# get variable from azd environment
$webAppName = azd env get-value WEB_APP_NAME
$resourceGroupName = azd env get-value RESOURCE_GROUP_NAME
$tenantId = azd env get-value AZURE_TENANT_ID
$environmentName = azd env get-value AZURE_ENV_NAME
$appDisplayName = "LeaderboardApp-$environmentName"

# reuse existing app registration when present to avoid duplicate apps
$existingAppRaw = az ad app list --display-name $appDisplayName --query "[0]"
if ($existingAppRaw -and $existingAppRaw -ne "null") {
	$AppRegistration = $existingAppRaw | ConvertFrom-Json
} else {
  	$AppRegistration = az ad app create --display-name $appDisplayName --sign-in-audience "AzureADMyOrg" --web-redirect-uris "https://$webAppName.azurewebsites.net/signin-oidc" --enable-id-token-issuance --enable-access-token-issuance | ConvertFrom-Json
}
$ClientId = $AppRegistration.appId


$passwordExpiry = (Get-Date).ToUniversalTime().AddDays($passwordDaysToExpiration).ToString("yyyy-MM-ddTHH:mm:ssZ")
$ClientSecret = (az ad app credential reset --id $ClientId --display-name $appDisplayName --append --end-date $passwordExpiry --query password -o tsv)

#get ad domain
$adDomain = (az rest --method get --url 'https://graph.microsoft.com/v1.0/domains?$select=id' | ConvertFrom-Json).value | Select-Object -First 1 -ExpandProperty id

Write-Host "📝 Update Web App configuration settings..." -ForegroundColor Yellow
az webapp config appsettings set --name $webAppName --resource-group $resourceGroupName --settings "AzureAd__ClientId=$ClientId" "AzureAd__TenantId=$tenantId" "AzureAd__ClientSecret=$ClientSecret" "AzureAd__Domain=$adDomain"

Write-Host "🌐 Restart Web app.."
az webapp restart --name $webAppName --resource-group $resourceGroupName