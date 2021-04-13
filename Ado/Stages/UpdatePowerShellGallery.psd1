@{
    stage = 'UpdatePowerShellGallery'
    displayName = 'Update'
    condition= "and(succeeded(), in(variables['Build.SourceBranch'], 'refs/heads/master', 'refs/heads/main'))"
    variables = @(@{
        group= 'Gallery'
    })
    jobs = @(@{
        job = 'Publish'
        displayName = 'PowerShell Gallery'
        pool=@{
            vmImage= 'windows-latest'
        }
        steps = @(@{
            checkout='self'
            clean=$true
            persistCredentials = $true
        },'PublishPowerShellGallery')
    })
}