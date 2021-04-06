Import-Module PSScriptAnalyzer, PSDevOps -PassThru | Out-Host
$invokeScriptAnalyzerSplat = @{Path='.\'}
if ($ENV:PSScriptAnalyzer_Recurse) {
    $invokeScriptAnalyzerSplat.Recurse = $true
}
$result = Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat

foreach ($r in $result) {
    if ('information', 'warning' -contains $r.Severity) {
        Write-GitHubWarning -Message "$($r.RuleName) : $($r.Message)" -SourcePath $r.ScriptPath -LineNumber $r.Line -ColumnNumber $r.Column
    }
    elseif ($r.Severity -eq 'Error') {
        Write-GitHubError -Message "$($r.RuleName) : $($r.Message)" -SourcePath $r.ScriptPath -LineNumber $r.Line -ColumnNumber $r.Column
    }
}