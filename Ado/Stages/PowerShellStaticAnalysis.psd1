@{
    stage = 'PowerShellStaticAnalysis'
    displayName = 'Static Analysis'
    condition= "succeeded()"
    jobs = @(@{
        job = 'PSScriptAnalyzer'
        displayName = 'PSScriptAnalyzer'
        pool=@{
            vmImage= 'windows-latest'
        }
        steps = @('InstallPSDevOps', 'InstallPSScriptAnalyzer','RunPSScriptAnalyzer')
    })
}
