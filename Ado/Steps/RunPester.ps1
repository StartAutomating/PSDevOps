<#
.Synopsis
    Runs Pester
.Description
    Runs Pester tests after importing a PowerShell module
#>
param(
# The module path.  If not provided, will default to the second half of the repository ID.
[string]
$ModulePath,
# The Pester max version.  By default, this is pinned to 4.99.99.
[string]
$PesterMaxVersion = '4.99.99'
)

$orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
if (-not $ModulePath) {
    $orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
    $ModulePath = ".\$moduleName.psd1"
}
Import-Module Pester -Force -PassThru -MaximumVersion $PesterMaxVersion | Out-Host
Import-Module $ModulePath -Force -PassThru | Out-Host
$result = 
    Invoke-Pester -PassThru -Verbose -OutputFile ".\$moduleName.TestResults.xml" -OutputFormat NUnitXml `
        -CodeCoverage "$(Build.SourcesDirectory)\*-*.ps1" -CodeCoverageOutputFile ".\$moduleName.Coverage.xml"

$psDevOpsImported = Import-Module PSDevOps -Force -PassThru -ErrorAction SilentlyContinue

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}