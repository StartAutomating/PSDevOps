param(
    [string]$ModulePath,
    [switch]$Recurse
)
Import-Module PSScriptAnalyzer, PSDevOps
if (-not $ModulePath) { $ModulePath = '.\'} 
$invokeScriptAnalyzerSplat = @{Path=$ModulePath}
if ($ENV:PSScriptAnalyzer_Recurse -or $Recurse) {
    $invokeScriptAnalyzerSplat.Recurse = $true
}
$result = @(Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat)
$violatedRules = $result | Select-Object -ExpandProperty RuleName

Write-ADOVariable -Name PSScriptAnalyzerIssueCount -Value $result.Length -IsOutput
Write-ADOVariable -Name PSScriptAnalyzerRulesViolated -Value ($violatedRules -join ',') -IsOutput
foreach ($r in $result) {
    if ('information', 'warning' -contains $r.Severity) {
        Write-ADOWarning -Message "$($r.RuleName) : $($r.Message)" -SourcePath $r.ScriptPath -LineNumber $r.Line -ColumnNumber $r.Column
    }
    elseif ($r.Severity -eq 'Error') {
        Write-ADOError -Message "$($r.RuleName) : $($r.Message)" -SourcePath $r.ScriptPath -LineNumber $r.Line -ColumnNumber $r.Column
    }
}