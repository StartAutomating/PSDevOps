param(
[string]
$PesterMaxVersion = '4.9.9'
)

$orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
Import-Module Pester -Force -PassThru -MaximumVersion $PesterMaxVersion
Import-Module ".\$moduleName.psd1" -Force -PassThru | Out-Host
$result = 
    Invoke-Pester -PassThru -Verbose -OutputFile ".\$moduleName.TestResults.xml" -OutputFormat NUnitXml `
        -CodeCoverage "$(Build.SourcesDirectory)\*-*.ps1" -CodeCoverageOutputFile ".\$moduleName.Coverage.xml"

$psDevOpsImported = Import-Module PSDevOps -Force -PassThru -ErrorAction SilentlyContinue

if ($psDevOpsImported) {
    foreach ($pesterTestResult in $pesterResults.TestResult) {
        if ($pesterTestResult.Result -eq 'Failed') {
            $foundLineNumber = [Regex]::Match($pesterTestResult.StackTrace, ':\s{0,}(?<Line>\d+)\s{0,}\w{1,}\s{0,}(?<File>.+)$', 'Multiline')
            $errSplat = @{
                Message = $pesterTestResult.ErrorRecord.Exception.Message
                Line = $foundLineNumber.Groups["Line"].Value
                SourcePath = $foundLineNumber.Groups["File"].Value
            }

            Write-ADOError @errSplat
        }    
    }    
} else {
    if ($result.FailedCount -gt 0) {
        throw "$($result.FailedCount) tests failed."
    }
}