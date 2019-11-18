@{
    job= 'Linux'
    displayName = 'on Linux'
    pool = @{vmImage='ubuntu-16.04'}
    steps = 'InstallPowerShellCoreOnLinux','InstallPester', 'RunPester','PublishTestResults','PublishCodeCoverage'   
}