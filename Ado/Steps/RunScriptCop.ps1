param([string]$ModulePath)
Import-Module ScriptCop, PSDevOps -PassThru | Out-host

if (-not $ModulePath) {
    $orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
    $ModulePath = ".\$moduleName.psd1"
}

if ($ModulePath -like '*PSDevOps*') { 
    Remove-Module PSDeVOps # If running ScriptCop on PSDeVOps, we need to remove the global module first.
}
"Importing from $ModulePath" | Out-Host 
$importedModule =Import-Module $ModulePath -Force -PassThru

$importedModule | Out-Host

Trace-ADOCommand -Command 'Test-Command' -Parameter @{Module=$importedModule}

$importedModule | 
    Test-Command |
    Tee-Object -Variable scriptCopIssues |
    Out-Host

$scriptCopIssues = @($scriptCopIssues | Sort-Object ItemWithProblem)
Write-ADOVariable -Name ScriptCopIssueCount -Value $scriptCopIssues.Length -IsOutput

foreach ($issue in $scriptCopIssues) {
    Write-ADOWarning -Message "$($issue.ItemWithProblem): $($issue.Problem)"

}
