param(
[string]
$ModulePath,

# The user email associated with a git commit.
[string]
$UserEmail,

# The user name associated with a git commit.
[string]
$UserName,

# The tag version format (default value: 'v$(imported.Version)')
# This can expand variables.  $imported will contain the imported module.
[string]
$TagVersionFormat = 'v$($imported.Version)',

# The release name format (default value: '$($imported.Name) $($imported.Version)')
[string]
$ReleaseNameFormat = '$($imported.Name) $($imported.Version)'
)


$gitHubEvent = if ($env:GITHUB_EVENT_PATH) {
    [IO.File]::ReadAllText($env:GITHUB_EVENT_PATH) | ConvertFrom-Json
} else { $null }


@"
::group::GitHubEvent
$($gitHubEvent | ConvertTo-Json -Depth 100)
::endgroup::
"@ | Out-Host

if (-not ($gitHubEvent.head_commit.message -match "Merge Pull Request #(?<PRNumber>\d+)") -and 
    (-not $gitHubEvent.psobject.properties['inputs'])) {
    "::warning::Pull Request has not merged, skipping GitHub release" | Out-Host
    return
}



$imported = 
if (-not $ModulePath) {
    $orgName, $moduleName = $env:GITHUB_REPOSITORY -split "/"
    Import-Module ".\$moduleName.psd1" -Force -PassThru -Global
} else {    
    Import-Module $modulePath -Force -PassThru -Global
}

if (-not $imported) { return } 

$targetVersion  =$ExecutionContext.InvokeCommand.ExpandString($TagVersionFormat)
$targetReleaseName = $targetVersion
$releasesURL    = 'https://api.github.com/repos/${{github.repository}}/releases'
"Release URL: $releasesURL" | Out-Host
$listOfReleases = Invoke-RestMethod -Uri $releasesURL -Method Get -Headers @{
    "Accept" = "application/vnd.github.v3+json"    
    "Authorization" = 'Bearer ${{ secrets.GITHUB_TOKEN }}'
}

$releaseExists = $listOfReleases | Where-Object tag_name -eq $targetVersion

if ($releaseExists) {
    "::warning::Release '$($releaseExists.Name )' Already Exists" | Out-Host
    return
}


Invoke-RestMethod -Uri $releasesURL -Method Post -Body (
    [Ordered]@{
        owner = '${{github.owner}}'
        repo  = '${{github.repository}}'
        tag_name = $targetVersion
        name = $ExecutionContext.InvokeCommand.ExpandString($ReleaseNameFormat)
        body = 
            if ($env:RELEASENOTES) {
                $env:RELEASENOTES
            } elseif ($imported.PrivateData.PSData.ReleaseNotes) {
                $imported.PrivateData.PSData.ReleaseNotes
            } else {
                "$($imported.Name) $targetVersion"
            }
        draft = if ($env:RELEASEISDRAFT) { [bool]::Parse($env:RELEASEISDRAFT) } else { $false }
        prerelease = if ($env:PRERELEASE) { [bool]::Parse($env:PRERELEASE) } else { $false }
    } | ConvertTo-Json
) -Headers @{
    "Accept" = "application/vnd.github.v3+json"
    "Content-type" = "application/json"
    "Authorization" = 'Bearer ${{ secrets.GITHUB_TOKEN }}'
}
