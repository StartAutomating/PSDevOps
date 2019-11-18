$orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
$imported = Import-Module ".\$moduleName.psd1" -Force -PassThru
$foundModule = Find-Module -Name $ModuleName
if ($foundModule.Version -ge $imported.Version) {
    Write-Warning "##vso[task.logissue type=warning]Gallery Version of $moduleName is more recent ($($foundModule.Version) >= $($imported.Version))"
} else {
    $gk = '$(GalleryKey)'
    $stagingDir = '$(Build.ArtifactStagingDirectory)'
    $moduleTempPath = Join-Path $stagingDir $moduleName
            
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