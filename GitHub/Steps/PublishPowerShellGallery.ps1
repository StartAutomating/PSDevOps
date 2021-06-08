param(
[string]
$ModulePath
)
$gitHubEvent = if ($env:GITHUB_EVENT_PATH) {
    [IO.File]::ReadAllText($env:GITHUB_EVENT_PATH) | ConvertFrom-Json
} else { $null }


@"
::group::GitHubEvent
$($gitHubEvent | ConvertTo-Json -Depth 100)
::endgroup::
"@ | Out-Host

if (-not ($gitHubEvent.pullrequest.merged) -and (-not $gitHubEvent.psobject.properties['input'])) {
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

$foundModule = try { Find-Module -Name $imported.Name -ErrorAction SilentlyContinue } catch {}

if ($foundModule -and $foundModule.Version -ge $imported.Version) {
    "::warning::Gallery Version of $moduleName is more recent ($($foundModule.Version) >= $($imported.Version))" | Out-Host        
} else {
    
    $gk = '${{secrets.GalleryKey}}'
    
    $moduleTempPath = Join-Path $pwd $moduleName
                    
    Write-Host "Staging Directory: $ModuleTempPath"
                            
    $imported | Split-Path | Copy-Item -Destination $moduleTempPath -Recurse
    $moduleGitPath = Join-Path $moduleTempPath '.git'
    Write-Host "Removing .git directory"
    Remove-Item -Recurse -Force $moduleGitPath
    Write-Host "Module Files:"
    Get-ChildItem $moduleTempPath -Recurse
    Write-Host "Publishing $moduleName [$($imported.Version)] to Gallery"
    Publish-Module -Path $moduleTempPath -NuGetApiKey $gk
    if ($?) {
        Write-Host "Published to Gallery"
    } else {
        Write-Host "Gallery Publish Failed"
        exit 1
    }
}
