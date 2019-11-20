Import-Module PSScriptAnalyzer, PSDevOps
$invokeScriptAnalyzerSplat = @{Path='.\'}
if ($ENV:PSScriptAnalyzer_Recurse) {
    $invokeScriptAnalyzerSplat.Recurse = $true
}
$result = Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat

foreach ($r in $result) {
    if ('information', 'warning' -contains $r.Severity) {
        Write-ADOWarning -Message $r.Message -SourcePath $r.ScriptPath -LineNumber $r.LineNumber -ColumnNumber $r.ColumnNumber
    }
    elseif ($r.Severity -eq 'Error') {
        Write-ADOError -Message $r.Message -SourcePath $r.ScriptPath -LineNumber $r.LineNumber -ColumnNumber $r.ColumnNumber
    }
}