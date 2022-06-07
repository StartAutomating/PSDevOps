
New-ADOWorkItemType
-------------------
### Synopsis
Creates custom work item types

---
### Description

Creates custom work item types in Azure DevOps.

Also creates custom rules or states for a work item type.

---
### Related Links
* [Get-ADOWorkItemType](Get-ADOWorkItemType.md)
* [Remove-ADOWorkItemType](Remove-ADOWorkItemType.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOProject -Organization StartAutomating -Project PSDevOps |
    Get-ADOWorkProcess |
        New-ADOWorkItemType -Name ServiceRequest -Color 'ddee00' -Icon icon_flame
```

#### EXAMPLE 2
```PowerShell
Get-ADOProject -Organization StartAutomating -Project PSDevOps | # Get a project
    Get-ADOWorkProcess |  # Get it's process
    Get-ADOWorkItemType|  # Get work item types
    Where-Object Name -eq 'Cmdlet' | # Filter the cmdlet type
    New-ADOWorkItemType -State Cancelled -Color 'ff2200' -StateCategory Removed  # create a new state.
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

The process identifier.  This can be piped in from Get-ADOWorkProcess.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Name**

The name of the custom work item type, custom work item type state, custom work item type rule, or custom work item type behavior.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Icon**

The name of the icon used for the custom work item.
To list available icons, use Get-ADOWorkItemType -Icon



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Color**

The color of the work item type or state.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Description**

The description for the custom work item type.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **InheritsFrom**

The work item type the custom work item should inherit, or the backlog behavior that should be inherited.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **IsDisabled**

If set, will create the work item type disabled.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **BehaviorID**

If set, will associate a given work item type with a behavior (for instance, adding a type of work item to be displayed in a backlog)



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **IsDefault**

If set, will make the given work item type the default within a particular behavior (for instance, making the work item type the default type of a backlog).



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Behavior**

If set, will create a new state for a custom work item instead of a custom work item.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **ReferenceName**

The Reference Name of a WorkItemType.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **State**

If set, will create a new state for a custom work item instead of a custom work item.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Order**

The order of the a custom state for a custom work item.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
#### **StateCategory**

The state category of a custom state for a custom work item.



Valid Values:

* Proposed
* InProgress
* Resolved
* Completed
* Removed
|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|true    |named  |false        |
---
#### **RuleConditionType**

The type of work item rule to create.



Valid Values:

* when
* whenChanged
* whenNot
* whenNotChanged
* whenStateChangedFromAndTo
* whenStateChangedTo
* whenValueIsDefined
* whenValueIsNotDefined
* whenWas
* whenWorkItemIsCreated
|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|true    |named  |true (ByPropertyName)|
---
#### **Field**

The field for a given rule condition.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **Value**

The value of a given rule condition.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **RuleActionType**

The type of action run when the work item rule is triggered.



Valid Values:

* copyFromClock
* copyFromCurrentUser
* copyFromField
* copyFromServerClock
* copyFromServerCurrentUser
* copyValue
* makeReadOnly
* makeRequired
* setDefaultFromClock
* setDefaultFromCurrentUser
* setDefaultFromField
* setDefaultValue
* setValueToEmpty
|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|true    |named  |true (ByPropertyName)|
---
#### **TargetField**

The target field for a given rule action.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **TargetValue**

The target value for a given rule action.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
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
PSDevOps.WorkItemType


PSDevOps.Rule


PSDevOps.State


PSDevOps.Behavior


---
### Syntax
```PowerShell
New-ADOWorkItemType -Organization <String> -ProcessID <String> [-Name] <String> [-Icon <String>] -Color <String> [-Description <String>] [-InheritsFrom <String>] [-IsDisabled] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOWorkItemType -Organization <String> -ProcessID <String> [-Name] <String> -Color <String> -InheritsFrom <String> -Behavior [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOWorkItemType -Organization <String> -ProcessID <String> [-BehaviorID <String>] [-IsDefault] -ReferenceName <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOWorkItemType -Organization <String> -ProcessID <String> [-Name] <String> -Color <String> -ReferenceName <String> -State [-Order <Int32>] -StateCategory <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOWorkItemType -Organization <String> -ProcessID <String> [-Name] <String> -ReferenceName <String> -RuleConditionType <String[]> [-Field <String[]>] [-Value <String[]>] -RuleActionType <String[]> [-TargetField <String[]>] [-TargetValue <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


