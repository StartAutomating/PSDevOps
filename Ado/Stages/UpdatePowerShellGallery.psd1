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
            vmImage= 'vs2017-win2016'
        }
        steps = @('PublishPowerShellGallery')
    })
}