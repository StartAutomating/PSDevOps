
Remove-ADOWorkItemType
----------------------
### Synopsis
Removes custom work item types.

---
### Description

Removes custom work item types from Azure DevOps.

Also removes custom work item type states, rules, and behaviors.

---
### Related Links
* [Get-ADOWorkItemType](Get-ADOWorkItemType.md)
* [New-ADOWorkItemType](New-ADOWorkItemType.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOProject -Organization $myOrganization -Project $myProject -PersonalAccessToken $myPat |
    Get-ADOWorkProcess |
    Remove-ADOWorkItemType -WorkItemTypeName ServiceRequest
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ProcessID**

The Process identifier.  This work process must contain the custom work item type.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **WorkItemTypeName**

The name of the custom work item type.  Values with a property 'ReferenceName' will be accepted.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **StateID**

The id of a custom work item state that will be removed.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **RuleID**

The id of a custom work item rule that will be removed.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **BehaviorID**

The id of a custom work item behavior that will be removed.



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


---
### Syntax
```PowerShell
Remove-ADOWorkItemType -Organization <String> -ProcessID <String> [-WorkItemTypeName] <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOWorkItemType -Organization <String> -ProcessID <String> [-WorkItemTypeName] <String> -BehaviorID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOWorkItemType -Organization <String> -ProcessID <String> [-WorkItemTypeName] <String> -RuleID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOWorkItemType -Organization <String> -ProcessID <String> [-WorkItemTypeName] <String> -StateID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


