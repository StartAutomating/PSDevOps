@{
    job = 'PSScriptAnalyzer'
    displayName = 'PSScriptAnalyzer'
    pool=@{
        vmImage= 'windows-latest'
    }
    steps = @('InstallPSDevOps', 'InstallPSScriptAnalyzer','RunPSScriptAnalyzer')
}
