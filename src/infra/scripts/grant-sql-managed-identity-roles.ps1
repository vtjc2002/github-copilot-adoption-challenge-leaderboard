param(
)

$ErrorActionPreference = 'Stop'

$SqlServerFqdn = (azd env get-value SQL_SERVER_FQDN).Trim()
$AppIdentity = (azd env get-value WEB_APP_NAME).Trim()
$sqlAccessToken = (az account get-access-token --resource https://database.windows.net --query accessToken -o tsv 2>$null)

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted | Out-Null
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
  Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber | Out-Null
}
Import-Module SqlServer | Out-Null

$connectionString = "Server=tcp:$SqlServerFqdn,1433;Database=leaderboarddb;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$escapedPrincipal = $AppIdentity.Replace("'", "''")


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

Invoke-Sqlcmd -ConnectionString $connectionString -AccessToken $sqlAccessToken -Query $query -QueryTimeout 60
