
Remove-ADOWorkItem
------------------
### Synopsis
Remove work items from Azure DevOps

---
### Description

Remove work item from Azure DevOps or Team Foundation Server.

---
### Related Links
* [Invoke-ADORestAPI](Invoke-ADORestAPI.md)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/delete?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/delete?view=azure-devops-rest-5.1)
---
### Examples
#### EXAMPLE 1
```PowerShell
Remove-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 10
```

#### EXAMPLE 2
```PowerShell
Remove-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query "Select [System.ID] from WorkItems Where [System.Title] = 'Test-WorkItem'" -PersonalAccessToken $pat -Confirm:$false
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Project**

The Project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ID**

The Work Item ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Query**

A query



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **QueryID**

If set, will return work item shared queries



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |named  |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Outputs
System.Nullable


System.Collections.IDictionary


---
### Syntax
```PowerShell
Remove-ADOWorkItem -Organization <String> -Project <String> -ID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOWorkItem -Organization <String> -Project <String> -Query <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOWorkItem -Organization <String> -Project <String> -QueryID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


