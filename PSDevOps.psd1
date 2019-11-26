@{
    ModuleVersion = '0.2.4'
    RootModule = 'PSDevOps.psm1'
    Description = 'PowerShell Tools for DevOps'
    Guid = 'e6b56c5f-41ac-4ba4-8b88-2c063f683176'
    PrivateData = @{
        PSData = @{
            Tags = 'ADO', 'AzureDevOps', 'PSDevOps', 'DevOps'
            ProjectURI = 'https://github.com/StartAutomating/PSDevOps'
            LicenseURI = 'https://github.com/StartAutomating/PSDevOps/blob/master/LICENSE'
            ReleaseNotes = @'
0.2.4
---
* Adding Adding -CanSortBy, -IsQueryable, and -ReadOnly to New-ADOField.
* Adding parameter help to New-ADOField
0.2.3
---
* Adding New/Remove-ADOField
* Adding help to Get-ADOField
* Adding formatting for fields
0.2.2
---
* Adding New/Set/Remove-ADOWorkItem
* Adding Get-ADOField
* New Parameter: Get-ADOWorkItem -WorkItemType
* New Parameter: New-ADOPipeline -Option
* Initial formatting
* Switching Parts to use latest VMImage

0.2.1 :
* Added Get-ADOWorkItem
---
0.2   :
---
* Added Invoke-ADORestAPI
0.1    :
---
Initial Commit
'@
        }
    }
    FormatsToProcess = 'PSDevOps.format.ps1xml'
    Author = 'James Brundage'
    Copyright = '2019 Start-Automating'
    PowerShellVersion ='3.0'
}