# Seed the Activities table in the leaderboard database with default scoring data.
# table creation is handled via EF Core migrations during app startup.

param(
  [string]$SqlFile
)

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

$sqlAccessToken = (& az account get-access-token --resource https://database.windows.net --query accessToken -o tsv 2>$null)
if ($LASTEXITCODE -ne 0) {
  throw 'Unable to acquire SQL access token via az CLI. Run "az login" and retry.'
}

$token = ($sqlAccessToken -join '').Trim()
if ([string]::IsNullOrWhiteSpace($token)) {
  throw 'Received an empty SQL access token from az CLI.'
}

$connectionString = "Server=tcp:$SqlServerFqdn,1433;Database=leaderboarddb;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
if (-not $SqlFile) {
  # Default path: two levels up from this script (src) then challenges-util\challenges-insert.sql
  $defaultRelative = '..\..\challenges-util\challenges-insert.sql'
  $SqlFile = Join-Path -Path $PSScriptRoot -ChildPath $defaultRelative
}

$resolved = Resolve-Path -Path $SqlFile -ErrorAction SilentlyContinue
if (-not $resolved) {
  throw "SQL file not found: $SqlFile"
}

# Read the SQL file as a single string. Use -Raw to preserve formatting and any multi-line scripts.
$query = Get-Content -Raw -Path $resolved -ErrorAction Stop

$connection = $null
$command = $null

try {
  $connection = [System.Data.SqlClient.SqlConnection]::new($connectionString)
  $connection.AccessToken = $token
  $connection.Open()

  $command = $connection.CreateCommand()
  $command.CommandType = [System.Data.CommandType]::Text

  # Many .sql files use GO batch separators which are not T-SQL statements and must be split.
  $batches = [regex]::Split($query, "(?im)^\s*GO\s*$")

  foreach ($batch in $batches) {
    $trimmed = $batch.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
      continue
    }

    $command.CommandText = $trimmed
    try {
      [void]$command.ExecuteNonQuery()
    }
    catch {
      throw "Failed executing SQL batch: $($_.Exception.Message)"
    }
  }
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

Write-Host "Executed SQL file: $resolved"
Write-Host 'Database insert script completed.'
