param([string]$ModulePath)
Import-Module ScriptCop, PSDevOps -PassThru | Out-Host

if (-not $ModulePath) {
    $orgName, $moduleName = $env:BUILD_REPOSITORY_ID -split "/"
    $ModulePath = ".\$moduleName.psd1"
}

if ($ModulePath -like '*PSDevOps*') { 
    Remove-Module PSDeVOps # If running ScriptCop on PSDeVOps, we need to remove the global module first.
} 
$importedModule =Import-Module $ModulePath -Force -PassThru 

$importedModule | Out-Host

$importedModule | 
    Test-Command |
    Tee-Object -Variable scriptCopIssues |
    Out-Host

foreach ($issue in $scriptCopIssues) {
    Write-ADOWarning -Message "$($issue.ItemWithProblem): $($issue.Problem)"
}
