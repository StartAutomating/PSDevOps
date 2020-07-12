@{
    "runs-on" = "ubuntu-latest"
    steps = @('InstallScriptCop', 'InstallPSScriptAnalyzer', 'InstallPSDevOps', 'RunScriptCop', 'RunPSScriptAnalyzer')
}
