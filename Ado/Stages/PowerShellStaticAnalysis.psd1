@{
    stage = 'PowerShellStaticAnalysis'
    displayName = 'Static Analysis'
    condition= "and(succeeded())"
    jobs = @(@{
        job = 'PSScriptAnalyzer'
        displayName = 'PSScriptAnalyzer'
        pool=@{
            vmImage= 'vs2017-win2016'
        }
        steps = @('InstallPSDevOps', 'InstallPSScriptAnalyzer','RunPSScriptAnalyzer')
    })
}
