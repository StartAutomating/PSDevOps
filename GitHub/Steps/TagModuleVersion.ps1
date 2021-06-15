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

# The tag version format (default value: '$($imported.Name) $(imported.Version)')
# This can expand variables.  $imported will contain the imported module.
[string]
$TagAnnotationFormat = '$($imported.Name) $($imported.Version)'
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
    "::warning::Pull Request has not merged, skipping" | Out-Host
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
$existingTags     = git tag --list

@"
Target Version: $targetVersion

Existing Tags:
$($existingTags  -join [Environment]::NewLine)
"@ | Out-Host

$versionTagExists = $existingTags | Where-Object { $_ -match $targetVersion } 

if ($versionTagExists) { 
    "::warning::Version $($versionTagExists)"
    return 
}

if (-not $UserName) { $UserName = $env:GITHUB_ACTOR }
if (-not $UserEmail) { $UserEmail = "$UserName@github.com" }
git config --global user.email $UserEmail
git config --global user.name  $UserName

git tag -a $targetVersion -m $ExecutionContext.InvokeCommand.ExpandString($TagAnnotationFormat)
git push origin --tags
 
if ($env:GITHUB_ACTOR) {
    exit 0
}