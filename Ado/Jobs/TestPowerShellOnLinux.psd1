@{
    job= 'Linux'
    displayName = 'Linux'
    pool = @{vmImage='ubuntu-latest'}
    steps = 'InstallPowerShellCoreOnLinux','InstallPester', 'RunPester','PublishTestResults','PublishCodeCoverage'   
}