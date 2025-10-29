# Seed the Activities table in the leaderboard database with default scoring data.
# table creation is handled via EF Core migrations during app startup.

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

$sqlAccessToken = (& az account get-access-token --resource https://database.windows.net --query accessToken -o tsv 2>$null)
if ($LASTEXITCODE -ne 0) {
  throw 'Unable to acquire SQL access token via az CLI. Run "az login" and retry.'
}

$token = ($sqlAccessToken -join '').Trim()
if ([string]::IsNullOrWhiteSpace($token)) {
  throw 'Received an empty SQL access token from az CLI.'
}

$connectionString = "Server=tcp:$SqlServerFqdn,1433;Database=leaderboarddb;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$query = @"
SET IDENTITY_INSERT Activities ON;

INSERT INTO Activities (ActivityId, Name, WeightType, Weight, Scope, Frequency) VALUES
(1, 'ActiveUsersPerDay', 'Multiplier', 50.00, 'User', 'Daily'),
(2, 'EngagedUsersPerDay', 'Multiplier', 75.00, 'User', 'Daily'),
(3, 'TotalCodeSuggestions', 'Multiplier', 1.00, 'Team', 'Daily'),
(4, 'TotalLinesAccepted', 'Multiplier', 1.50, 'Team', 'Daily'),
(5, 'TotalChats', 'Multiplier', 10.00, 'Team', 'Daily'),
(6, 'TotalChatInsertions', 'Multiplier', 50.00, 'Team', 'Daily'),
(7, 'TotalChatCopyEvents', 'Multiplier', 30.00, 'Team', 'Daily'),
(8, 'TotalPRSummariesCreated', 'Multiplier', 100.00, 'Team', 'Daily'),
(9, 'TotalDotComChats', 'Multiplier', 20.00, 'Team', 'Daily'),
(10, 'CompletedLearningModule', 'Fixed', 250.00, 'User', 'Once'),
(11, 'GitHubCopilotCertificationExam', 'Fixed', 1000.00, 'User', 'Once'),
(12, 'CopilotDailyChallengeCompleted', 'Fixed', 200.00, 'User', 'Daily'),
(13, 'LinkClicked', 'Fixed', 50.00, 'User', 'Once'),
(14, 'TeamBonus', 'Fixed', 50.00, 'Team', 'Once');

SET IDENTITY_INSERT Activities OFF;
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

Write-Host 'Activities table seeded with default scoring data.'
