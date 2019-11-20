@{
    stage = 'PowerShellStaticAnalysis'
    displayName = 'Static Analysis'
    condition= "succeeded()"
    jobs = @(@{
        job = 'PSScriptAnalyzer'
        displayName = 'PSScriptAnalyzer'
        pool=@{
            vmImage= 'vs2017-win2016'
        }
        steps = @('InstallPSDevOps', 'InstallPSScriptAnalyzer','RunPSScriptAnalyzer')
    })
}
