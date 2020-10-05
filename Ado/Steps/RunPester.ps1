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

$Global:ErrorActionPreference = 'continue'
$Global:ProgressPreference    = 'silentlycontinue'

$result = 
    Invoke-Pester -PassThru -Verbose -OutputFile ".\$moduleName.TestResults.xml" -OutputFormat NUnitXml `
        -CodeCoverage "$(Build.SourcesDirectory)\*-*.ps1" -CodeCoverageOutputFile ".\$moduleName.Coverage.xml"

"##vso[task.setvariable variable=FailedCount;isoutput=true]$($result.FailedCount)",
"##vso[task.setvariable variable=PassedCount;isoutput=true]$($result.PassedCount)",
"##vso[task.setvariable variable=TotalCount;isoutput=true]$($result.TotalCount)" |
    Out-Host

if ($result.FailedCount -gt 0) {
    foreach ($r in $result.TestResult) {
        if (-not $r.Passed) {
            "##[error]$($r.describe, $r.context, $r.name -join ' ') $($r.FailureMessage)"
        }
    }
    throw "$($result.FailedCount) tests failed."
}

