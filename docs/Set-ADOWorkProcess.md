
Set-ADOWorkProcess
------------------
### Synopsis
Sets work processes in ADO.

---
### Description

Sets work processes in Azure DevOps.

Can:
* -Enable/-Disable processes
* Set a -Default process
* Provide a -NewName
* Update the -Description

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/edit%20process](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/edit%20process)
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
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ProjectID**

The Project Identifier.  If this is provided, will get the work process associated with that project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ProcessID**

The process identifier



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Default**

If set, will make the work process the default for new projects.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **NewName**

If provided, will rename the work process.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Description**

If provided, will update the description on the work process.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Disable**

If set, will disable the work process.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Enable**

If set, will enable the work process.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
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
PSDevOps.WorkProcess


---
### Syntax
```PowerShell
Set-ADOWorkProcess -Organization <String> [-Default] [-NewName <String>] [-Description <String>] [-Disable] [-Enable] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOWorkProcess -Organization <String> -ProjectID <String> [-Default] [-NewName <String>] [-Description <String>] [-Disable] [-Enable] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOWorkProcess -Organization <String> -ProcessID <String> [-Default] [-NewName <String>] [-Description <String>] [-Disable] [-Enable] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


