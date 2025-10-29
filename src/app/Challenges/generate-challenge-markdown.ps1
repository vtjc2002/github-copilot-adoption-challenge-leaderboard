# Parses insert.sql in current folder and creates one markdown file per challenge Content.
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$insertFile = Join-Path $scriptPath 'insert.sql'
if (!(Test-Path $insertFile)) { Write-Error "insert.sql not found"; exit 1 }

$sql = Get-Content $insertFile -Raw
# Regex to capture Title and Content values inside INSERT statements for Challenges table
$pattern = "INSERT INTO \[dbo\]\.\[Challenges\]\s*\(Title, Content, PostedDate, ActivityId\) VALUES \(N'(?<title>[^']+)', N'(?<content>(?:''|[^'])*?)',"

[System.Text.RegularExpressions.Regex]::Matches($sql, $pattern) | ForEach-Object {
    $title = $_.Groups['title'].Value.Trim()
    $rawContent = $_.Groups['content'].Value
    # Unescape doubled single quotes
    $html = $rawContent -replace "''", "'"
    # Slug for filename
    $slug = ($title.ToLower() -replace "[^a-z0-9]+","-").Trim('-')
    $file = Join-Path $scriptPath ("{0}.md" -f $slug)
    $frontMatter = "---`nTitle: $title`nSource: insert.sql`n---`n"
    Set-Content -Path $file -Value ($frontMatter + $html) -Encoding UTF8
    Write-Host "Created $file"
}

Write-Host "Done."