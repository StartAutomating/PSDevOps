@{
    "runs-on" = "ubuntu-latest"
    steps = @(
        'InstallScriptCop', 
        'InstallPSScriptAnalyzer', 
        'InstallPSDevOps', 
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        },
        'RunScriptCop', 
        'RunPSScriptAnalyzer'
    )
}
