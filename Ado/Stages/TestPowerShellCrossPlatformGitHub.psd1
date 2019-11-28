@{
    stage = 'TestPowerShellCrossPlatform'
    displayName = 'Test'
    jobs = 'TestPowerShellOnWindows', 'TestPowerShellOnLinux', 'TestPowerShellOnMac'
    condition= "succeeded()"
}