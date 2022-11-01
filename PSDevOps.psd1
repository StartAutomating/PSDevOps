@{
    ModuleVersion = '0.5.9'
    RootModule = 'PSDevOps.psm1'
    Description = 'PowerShell Tools for DevOps'
    Guid = 'e6b56c5f-41ac-4ba4-8b88-2c063f683176'
    PrivateData = @{
        PSData = @{
            Tags = 'ADO', 'AzureDevOps', 'PSDevOps', 'DevOps'
            ProjectURI = 'https://github.com/StartAutomating/PSDevOps'
            LicenseURI = 'https://github.com/StartAutomating/PSDevOps/blob/master/LICENSE'
            ReleaseNotes = @'
## 0.5.9:
* New-GitHubAction:  Adding -OutputPath (#162)
* New-GitHubWorkflow:  Adding -OutputPath (#163)
* New-ADOPipeline:  Adding -OutputPath (#164)
* Updating Action (Preferring local bits and other cleanup) (#165)
* Import-BuildStep: Adding -SourceFile and -BuildStepName (Fixes #153)
* Updating ReleaseModule Step:  Allowing -ReleaseAsset (Fixes #160)
* PublishPowerShellGallery :  Adding -Exclude (Fixes #159).  Fixing Module Version Comparison (Fixes #149)
* Connect-ADO:  Adding -NoCache (Fixes #150)
* Convert-BuildStep:  Fixing Github object parameter behavior (Fixes #158)
* Adding Get-ADOServiceHealth (Fixes #152)
* Adding Get-ADOAuditLog (Fixes #151)
* Adding PSDevOps.PSSVG.ps1 (Fixes #157)
* Updating Workflow (Fixes #155 Fixes #156)
* Adding GitHub/On/Issue (Fixes #154)

---

## 0.5.8:
* Running EZOut in Workflow (#148)
* Adding support for HelpOut (#147)
* Updating action (pushing changes) #144
* Updating GitHub Workflow steps/jobs - adding support for HelpOut and EZOut
* Initial Version of PSDevOps Action (#144)
* Adding Remove-ADOPermission (#143)
* Set-ADOPermission:  Fixing help typo
* Adding FlushRequestQueue Part
* Fixing Refactoring Related Import Issue
* Adding Initial Extensions (related to -ADOTest commands)
* Add-ADOTest:  Initial Commit
* Get-ADOBuild:  Passing along ProjectID and ProjectName
* Get/Set-ADOPermission:  Repov2 issue (#140)
* Recategorizing Functions

---


## 0.5.7:
* Fixing issue with setting branch permissions (#136)
* Get/Set-ADOPermission:  Support for ServiceEndpoints (#137)
* Set-ADOPermission:  Exposing specialized parameter sets (#138)
* PSDevOps.WorkProcess objects now return .ProcessName and .ProcessID as alias properties

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