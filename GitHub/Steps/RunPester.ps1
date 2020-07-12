param(
[string]
$ModulePath,
[string]
$PesterMaxVersion = '4.99.99'
)

$orgName, $moduleName = $env:GITHUB_REPOSITORY -split "/"
if (-not $ModulePath) {
    $orgName, $moduleName = $env:GITHUB_REPOSITORY -split "/"
    $ModulePath = ".\$moduleName.psd1"
}
$importedPester = Import-Module Pester -Force -PassThru -MaximumVersion $PesterMaxVersion
$importedModule = Import-Module $ModulePath -Force -PassThru
$importedPester, $importedModule | Out-Host


$result = 
    Invoke-Pester -PassThru -Verbose -OutputFile ".\$moduleName.TestResults.xml" -OutputFormat NUnitXml `
        -CodeCoverage "$($importedModule | Split-Path)\*-*.ps1" -CodeCoverageOutputFile ".\$moduleName.Coverage.xml"

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}
