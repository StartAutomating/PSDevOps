@{
    job = 'MacOS'
    displayName = 'MacOS'
    pool = @{vmImage='macos-latest'}
    steps = 'InstallPowerShellCoreOnMacOS','InstallPester', 'RunPester','PublishTestResults','PublishCodeCoverage'
}