
Set-ADOTeam
-----------
### Synopsis
Sets properties of an Azure DevOps team

---
### Description

Sets metadata for an Azure DevOps team.

---
### Related Links
* [Get-ADOTeam](Get-ADOTeam.md)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/work/teamsettings/update](https://docs.microsoft.com/en-us/rest/api/azure/devops/work/teamsettings/update)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOTeam -Organization MyOrganization -Project MyProject -Team MyTeam |
    Set-ADOTeam -Setting @{
        Custom = 'Value'
    }
```

---
### Parameters
#### **Organization**

The Organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Project**

The project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Team**

The team.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Setting**

A dictionary of team settings.  This is directly passed to the REST api.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |named  |true (ByPropertyName)|
---
#### **Workday**

The team working days.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **DefaultIteration**

The default iteration for the team.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **BugBehavior**

The bug behavior for the team.



Valid Values:

* AsRequirements
* AsTasks
* Off
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **DefaultAreaPath**

The default area path used for a team.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **AreaPath**

A list of valid area paths used for a team



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **IncludeChildren**

If set, will allow work items on the team to be assigned to child area paths of any -AreaPath.



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

The api version.  By default, 5.1-preview.
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


System.Management.Automation.PSObject


---
### Syntax
```PowerShell
Set-ADOTeam -Organization <String> -Project <String> -Team <String> [-DefaultAreaPath <String>] [-AreaPath <String[]>] [-IncludeChildren] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOTeam -Organization <String> -Project <String> -Team <String> [-Setting <IDictionary>] [-Workday <String[]>] [-DefaultIteration <String>] [-BugBehavior <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


