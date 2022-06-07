
New-ADOWorkItem
---------------
### Synopsis
Creates new work items in Azure DevOps

---
### Description

Creates new work items in Azure DevOps or Team Foundation Server.

---
### Related Links
* [Invoke-ADORestAPI](Invoke-ADORestAPI.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
@{ Title='New Work Item'; Description='A Description of the New Work Item' } |
    New-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Type Issue
```

---
### Parameters
#### **InputObject**

The InputObject



|Type            |Requried|Postion|PipelineInput                 |
|----------------|--------|-------|------------------------------|
|```[PSObject]```|true    |named  |true (ByValue, ByPropertyName)|
---
#### **Type**

The type of the work item.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **QueryName**

If set, will create a shared query for work items.  The -InputObject will be passed to the body.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **QueryPath**

If provided, will create shared queries beneath a given folder.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **WIQL**

If provided, create a shared query with a given WIQL.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **QueryType**

If provided, the shared query created may be hierchical



Valid Values:

* Flat
* OneHop
* Tree
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **QueryRecursiveOption**

The recursion option for use in a tree query.



Valid Values:

* childFirst
* parentFirst
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **FolderName**

If provided, create a shared query folder.



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
New-ADOWorkItem -InputObject <PSObject> -Type <String> [-ParentID <String>] -Organization <String> -Project <String> [-Relationship <IDictionary>] [-Comment <PSObject[]>] [-Tag <String[]>] [-BypassRule] [-ValidateOnly] [-SupressNotification] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOWorkItem -QueryName <String> [-QueryPath <String>] -WIQL <String> [-QueryType <String>] [-QueryRecursiveOption <String>] -Organization <String> -Project <String> [-Tag <String[]>] [-ValidateOnly] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOWorkItem [-QueryPath <String>] -FolderName <String> -Organization <String> -Project <String> [-Tag <String[]>] [-ValidateOnly] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


