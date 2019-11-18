@{
    job = 'Windows'
    displayName = 'Windows'
    pool = @{vmImage='vs2017-win2016'}
    steps = 'InstallPester', 'RunPester','PublishTestResults','PublishCodeCoverage'    
}