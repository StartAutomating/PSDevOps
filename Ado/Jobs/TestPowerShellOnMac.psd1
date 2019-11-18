@{
    job = 'MacOS'
    displayName = 'on MacOS'
    pool = @{vmImage='xcode9-macos10.13'}
    steps = 'InstallPowerShellCoreOnMacOS','InstallPester', 'RunPester','PublishTestResults','PublishCodeCoverage'
}