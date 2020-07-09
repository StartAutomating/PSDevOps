Import-Module PSScriptAnalyzer, PSDevOps
$invokeScriptAnalyzerSplat = @{Path='.\'}
if ($ENV:PSScriptAnalyzer_Recurse) {
    $invokeScriptAnalyzerSplat.Recurse = $true
}
$result = Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat

foreach ($r in $result) {
    if ('information', 'warning' -contains $r.Severity) {
        Write-ADOWarning -Message "$($r.RuleName) : $($r.Message)" -SourcePath $r.ScriptPath -LineNumber $r.Line -ColumnNumber $r.Column
    }
    elseif ($r.Severity -eq 'Error') {
        Write-ADOError -Message "$($r.RuleName) : $($r.Message)" -SourcePath $r.ScriptPath -LineNumber $r.Line -ColumnNumber $r.Column
    }
}