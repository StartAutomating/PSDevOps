# Traces the GitHub Event
$gitHubEvent = if ($env:GITHUB_EVENT_PATH) {
    [IO.File]::ReadAllText($env:GITHUB_EVENT_PATH) | ConvertFrom-Json
} else { $null }

@"
$($gitHubEvent | ConvertTo-Json -Depth 100)
"@ | Out-Host
