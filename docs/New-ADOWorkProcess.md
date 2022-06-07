
New-ADOWorkProcess
------------------
### Synopsis
Creates work processes in ADO.

---
### Description

Creates work processes in Azure DevOps.

Must provide a -Name

Can Provide:
* -Description
* -ParentProcessID (can be piped in, will default to the ID for 'Agile')
* -ReferenceName

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/create](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/create)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOWorkProcess -Organization StartAutomating -PersonalAccessToken $pat |
    Where-Object Name -Ne TheNameOfTheCurrentProcess |
    Set-ADOWorkProcess -Disable
```

#### EXAMPLE 2
```PowerShell
Get-ADOProject -Organization StartAutomating -PersonalAccessToken $pat |
    Get-ADOWorkProcess |
    Set-ADOWorkPrcoess -Description "Updating Description"
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Name**

The name of the work process



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |2      |true (ByPropertyName)|
---
#### **Description**

A description of the work process.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |3      |true (ByPropertyName)|
---
#### **ParentProcessID**

The parent process identifier.  If not provided, will default to the process ID for 'Agile'.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |4      |true (ByPropertyName)|
---
#### **ReferenceName**

A reference name for the work process.  If one is not provided, Azure Devops will automatically generate one.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |5      |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |6      |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |7      |false        |
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
PSDevOps.WorkProcess


---
### Syntax
```PowerShell
New-ADOWorkProcess [-Organization] <String> [-Name] <String> [[-Description] <String>] [[-ParentProcessID] <String>] [[-ReferenceName] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


