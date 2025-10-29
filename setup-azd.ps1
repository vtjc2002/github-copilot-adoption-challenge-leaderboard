# Azure Developer CLI Setup Script for Leaderboard App
# This script helps set up the environment and provision infrastructure

param(
    [string]$TenantId,
    [string]$SubscriptionId,
    [string]$Location = "eastus2",
    [string]$EnvironmentName = "lbapp"
    
)

Write-Host "🚀 Setting up Azure Developer CLI for Leaderboard App" -ForegroundColor Green

# Check if azd is installed
try {
    $azdVersion = azd version
    Write-Host "✅ Azure Developer CLI is installed: $azdVersion" -ForegroundColor Green
}
catch {
    Write-Host "❌ Azure Developer CLI not found. Please install from: https://aka.ms/azd-install" -ForegroundColor Red
    exit 1
}

# Authenticate with Azure
Write-Host "🔑 Authenticating with Azure..." -ForegroundColor Yellow
if ($TenantId) {
    Write-Host "   Using tenant ID $TenantId" -ForegroundColor Gray
    azd auth login --tenant-id $TenantId
}
else {
    azd auth login
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Authentication failed" -ForegroundColor Red
    exit 1
}

# create or select environment
Write-Host "🌍 Creating or selecting azd environment '$EnvironmentName'..." -ForegroundColor Yellow
azd env select $EnvironmentName
if ($LASTEXITCODE -ne 0) {
    Write-Host "ℹ️ Environment '$EnvironmentName' not found. Creating a new one..." -ForegroundColor Yellow
    azd env new $EnvironmentName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to create new environment '$EnvironmentName'" -ForegroundColor Red
        exit 1
    }
}
# ...existing code...


# Set environment variables
Write-Host "📝 Setting environment name to $EnvironmentName..." -ForegroundColor Yellow
azd env set AZURE_ENV_NAME $EnvironmentName

Write-Host "📝 Setting location to $Location..." -ForegroundColor Yellow
azd env set AZURE_LOCATION $Location

if ($SubscriptionId) {
    Write-Host "📝 Setting subscription ID..." -ForegroundColor Yellow
    azd env set AZURE_SUBSCRIPTION_ID $SubscriptionId
}

if ($TenantId) {
    Write-Host "📝 Setting tenant ID..." -ForegroundColor Yellow
    azd env set AZURE_TENANT_ID $TenantId
}

Write-Host "🔍 Retrieving current Azure AD user information..." -ForegroundColor Yellow
$userInfoJson = az ad signed-in-user show --query "{objectId:id,upn:userPrincipalName}" -o json 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($userInfoJson)) {
    Write-Host "❌ Unable to determine the signed-in Azure AD user. Ensure you have permissions to call Microsoft Graph." -ForegroundColor Red
    exit 1
}
$userInfo = $userInfoJson | ConvertFrom-Json

Write-Host "🌐 Detecting current public IPv4 address..." -ForegroundColor Yellow
try {
    $clientIp = (Invoke-RestMethod -Uri 'https://api.ipify.org')
} catch {
    Write-Host "❌ Failed to retrieve public IPv4 address." -ForegroundColor Red
    exit 1
}

Write-Host "🔐 Requesting Azure SQL access token for the current user..." -ForegroundColor Yellow
$sqlAccessToken = az account get-access-token --resource https://database.windows.net --query accessToken -o tsv 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sqlAccessToken)) {
    Write-Host "❌ Failed to acquire access token for https://database.windows.net." -ForegroundColor Red
    exit 1
}

Write-Host "📝 Persisting SQL administrator context in the azd environment..." -ForegroundColor Yellow
azd env set SQL_ADMIN_OBJECT_ID $($userInfo.objectId)
azd env set SQL_ADMIN_LOGIN $($userInfo.upn)
azd env set SQL_CLIENT_IP $clientIp
azd env set SQL_ACCESS_TOKEN $sqlAccessToken

Write-Host "⚠️ The SQL access token expires in approximately one hour. Run 'azd up' before it expires." -ForegroundColor Yellow

# Preview deployment
Write-Host "🔍 Running deployment preview..." -ForegroundColor Yellow
Write-Host "This will show what resources will be created without actually creating them." -ForegroundColor Gray

azd provision --preview

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Preview failed. Please check the error messages above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Review the preview above" -ForegroundColor White
Write-Host "2. If everything looks good, run: azd up" -ForegroundColor White
Write-Host ""
Write-Host "For more information, see DEPLOYMENT.md" -ForegroundColor Gray