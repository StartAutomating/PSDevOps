@{
    stage = 'PowerShellStaticAnalysis'
    displayName = 'Static Analysis'
    condition= "succeeded()"
    jobs = @('InstallAndRunPSScriptAnalyzer', 'InstallAndRunScriptCop')
}
