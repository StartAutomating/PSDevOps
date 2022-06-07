
Set-ADOWorkItem
---------------
### Synopsis
Sets work items from Azure DevOps

---
### Description

Sets work item from Azure DevOps or Team Foundation Server.

---
### Related Links
* [Invoke-ADORestAPI](Invoke-ADORestAPI.md)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/update](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/update)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query%20by%20wiql?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query%20by%20wiql?view=azure-devops-rest-5.1)
---
### Examples
#### EXAMPLE 1
```PowerShell
@{ 'Verb' ='Get' ;'Noun' = 'ADOWorkItem' } |
    Set-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 4
```

#### EXAMPLE 2
```PowerShell
Set-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query "Select [System.ID] from WorkItems Where [System.State] = 'To Do' and [System.AssignedTo] = @Me" -InputObject @{
    State = 'Doing'
}
```

#### EXAMPLE 3
```PowerShell
Set-ADOWorkItem -Organization TestOrg -Project Test -ID 123 -InputObject @{
    Version = 'Updating Custom Version Field Despite Being Read Only'
} -PersonalAccessToken $myPat -BypassRule
```

---
### Parameters
#### **InputObject**

The InputObject



|Type            |Requried|Postion|PipelineInput                 |
|----------------|--------|-------|------------------------------|
|```[PSObject]```|false   |named  |true (ByValue, ByPropertyName)|
---
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
#### **ParentID**

The work item ParentID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Relationship**

A collection of relationships for the work item.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |named  |true (ByPropertyName)|
---
#### **Comment**

A list of comments to be added to the work item.



|Type              |Requried|Postion|PipelineInput        |
|------------------|--------|-------|---------------------|
|```[PSObject[]]```|false   |named  |true (ByPropertyName)|
---
#### **Tag**

A list of tags to assign to the work item.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **BypassRule**

If set, will not validate rules.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **ValidateOnly**

If set, will only validate rules, but will not update the work item.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **SupressNotification**

If set, will only validate rules, but will not update the work item.



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
PSDevOps.WorkItem


---
### Syntax
```PowerShell
Set-ADOWorkItem [-InputObject <PSObject>] -Organization <String> -Project <String> -ID <String> [-ParentID <String>] [-Relationship <IDictionary>] [-Comment <PSObject[]>] [-Tag <String[]>] [-BypassRule] [-ValidateOnly] [-SupressNotification] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOWorkItem [-InputObject <PSObject>] -Organization <String> -Project <String> -Query <String> [-ParentID <String>] [-Relationship <IDictionary>] [-Comment <PSObject[]>] [-Tag <String[]>] [-BypassRule] [-ValidateOnly] [-SupressNotification] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


