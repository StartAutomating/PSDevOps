@{
    job = 'Windows'
    displayName = 'Windows'
    pool = @{vmImage='windows-latest'}
    steps = 'InstallPester', 'RunPester','PublishTestResults','PublishCodeCoverage'    
}