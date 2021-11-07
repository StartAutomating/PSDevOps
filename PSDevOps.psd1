@{
    ModuleVersion = '0.5.6'
    RootModule = 'PSDevOps.psm1'
    Description = 'PowerShell Tools for DevOps'
    Guid = 'e6b56c5f-41ac-4ba4-8b88-2c063f683176'
    PrivateData = @{
        PSData = @{
            Tags = 'ADO', 'AzureDevOps', 'PSDevOps', 'DevOps'
            ProjectURI = 'https://github.com/StartAutomating/PSDevOps'
            LicenseURI = 'https://github.com/StartAutomating/PSDevOps/blob/master/LICENSE'
            ReleaseNotes = @'
0.5.6:
---
### Azure DevOps Improvements
* Get-ADOPermission    :  Can now get permissions related to Dashboards, Analytics, AreaPaths, and IterationPaths
* Set-ADOPermission    :  Now can easily set permissions based off of a variety of pipeline inputs (Fixes #128 and #91)
* Get-ADOAreaPath      :  Removing "Area" from paths passed in, formatting returns with 'AreaPath' instead of 'Path'
* Get-ADOIterationPath :  Removing "Iteration" from paths passed in, formatting returns with 'IterationPath' instead of 'Path'
* Get-ADOBuild         :  Extended Type Definitions now contain an alias property of BuildPath
### GitHub Workflow Improvements
* Adding "On" files for issue creation, deletion, or modification (Fixes #132)
* Adding "On" files for common scheduling needs (Fixes #134)
* ReleaseNameFormat can not be customized in ReleaseModule step (Fixes #130)

Previous Release Notes available in [CHANGELOG.md](https://github.com/StartAutomating/PSDevOps/blob/master/CHANGELOG.md)
'@
        }
        Colors = @{
            Build = @{
                Succeeded = '#00ff00'
                Failed = '#ff0000'
            }
        }
    }
    FormatsToProcess = 'PSDevOps.format.ps1xml'
    TypesToProcess = 'PSDevOps.types.ps1xml'
    Author = 'James Brundage'
    Copyright = '2019 Start-Automating'
    PowerShellVersion ='3.0'
}