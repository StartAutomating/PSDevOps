$orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
Import-Module ".\$moduleName.psd1" -Force -PassThru | Out-Host
$result = 
    Invoke-Pester -PassThru -Verbose -OutputFile ".\$moduleName.TestResults.xml" -OutputFormat NUnitXml `
        -CodeCoverage "$(Build.SourcesDirectory)\*-*.ps1" -CodeCoverageOutputFile ".\$moduleName.Coverage.xml"
if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}