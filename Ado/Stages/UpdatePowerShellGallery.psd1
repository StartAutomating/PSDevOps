@{
    stage = 'UpdatePowerShellGallery'
    displayName = 'Update'
    condition= "and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/master'))"
    variables = @(@{
        group= 'Gallery'
    })
    jobs = @(@{
        job = 'Publish'
        displayName = 'PowerShell Gallery'
        pool=@{
            vmImage= 'windows-latest'
        }
        steps = @('PublishPowerShellGallery')
    })
}