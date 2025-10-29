# add web app managed identity roles to sql db and restart web app to pick up changes

param()

$ErrorActionPreference = 'Stop'

function Assert-CommandExists {
  param(
    [Parameter(Mandatory = $true)][string]$Name
  )

  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Required CLI '$Name' is not available in the current session. Install it and retry."
  }
}

Assert-CommandExists -Name 'azd'
Assert-CommandExists -Name 'az'

function Get-AzdEnvValue {
  param(
    [Parameter(Mandatory = $true)][string]$Name
  )

  $value = (& azd env get-value $Name 2>$null)
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to resolve azd environment value '$Name'. Ensure the value is defined."
  }

  $trimmed = ($value -join '').Trim()
  if ([string]::IsNullOrWhiteSpace($trimmed)) {
    throw "azd environment value '$Name' is empty."
  }

  return $trimmed
}

$SqlServerFqdn = Get-AzdEnvValue -Name 'SQL_SERVER_FQDN'
$AppIdentity = Get-AzdEnvValue -Name 'WEB_APP_NAME'
$ResourceGroupName = Get-AzdEnvValue -Name 'RESOURCE_GROUP_NAME'

$sqlAccessToken = (& az account get-access-token --resource https://database.windows.net --query accessToken -o tsv 2>$null)
if ($LASTEXITCODE -ne 0) {
  throw 'Unable to acquire SQL access token via az CLI. Run "az login" and retry.'
}

$token = ($sqlAccessToken -join '').Trim()
if ([string]::IsNullOrWhiteSpace($token)) {
  throw 'Received an empty SQL access token from az CLI.'
}

$connectionString = "Server=tcp:$SqlServerFqdn,1433;Database=leaderboarddb;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$escapedPrincipal = $AppIdentity.Replace("'", "''")

# Ensure the managed identity exists in the database and holds required roles.
$query = @"
DECLARE @principal sysname = N'$escapedPrincipal';
DECLARE @principalQuoted nvarchar(260) = QUOTENAME(@principal);

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @principal)
  EXEC(N'CREATE USER ' + @principalQuoted + N' FROM EXTERNAL PROVIDER;');

IF NOT EXISTS (
  SELECT 1
  FROM sys.database_role_members rm
  JOIN sys.database_principals rp ON rm.role_principal_id = rp.principal_id
  JOIN sys.database_principals up ON rm.member_principal_id = up.principal_id
  WHERE rp.name = 'db_datareader'
    AND up.name = @principal
)
  EXEC(N'ALTER ROLE db_datareader ADD MEMBER ' + @principalQuoted + N';');

IF NOT EXISTS (
  SELECT 1
  FROM sys.database_role_members rm
  JOIN sys.database_principals rp ON rm.role_principal_id = rp.principal_id
  JOIN sys.database_principals up ON rm.member_principal_id = up.principal_id
  WHERE rp.name = 'db_datawriter'
    AND up.name = @principal
)
  EXEC(N'ALTER ROLE db_datawriter ADD MEMBER ' + @principalQuoted + N';');

IF NOT EXISTS (
  SELECT 1
  FROM sys.database_role_members rm
  JOIN sys.database_principals rp ON rm.role_principal_id = rp.principal_id
  JOIN sys.database_principals up ON rm.member_principal_id = up.principal_id
  WHERE rp.name = 'db_ddladmin'
    AND up.name = @principal
)
  EXEC(N'ALTER ROLE db_ddladmin ADD MEMBER ' + @principalQuoted + N';');
"@

$connection = $null
$command = $null

try {
  $connection = [System.Data.SqlClient.SqlConnection]::new($connectionString)
  $connection.AccessToken = $token
  $connection.Open()

  $command = $connection.CreateCommand()
  $command.CommandText = $query
  $command.CommandType = [System.Data.CommandType]::Text
  [void]$command.ExecuteNonQuery()
}
finally {
  if ($command) {
    $command.Dispose()
  }

  if ($connection) {
    if ($connection.State -ne [System.Data.ConnectionState]::Closed) {
      $connection.Close()
    }

    $connection.Dispose()
  }
}

Write-Host "Managed identity '$AppIdentity' ensured with required database roles."

Write-Host "🌐 Restart Web app..and sleep for 30 seconds to let changes take effect."
az webapp restart --name $AppIdentity --resource-group $ResourceGroupName

sleep 30
Write-Host "✅ Done."

