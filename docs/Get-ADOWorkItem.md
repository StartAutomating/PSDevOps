Get-ADOWorkItem
---------------
### Synopsis
Gets work items from Azure DevOps

---
### Description

Gets work item from Azure DevOps or Team Foundation Server.

---
### Related Links
* [Invoke-ADORestAPI](Invoke-ADORestAPI.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/get%20work%20item?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/get%20work%20item?view=azure-devops-rest-5.1)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query%20by%20wiql?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query%20by%20wiql?view=azure-devops-rest-5.1)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 1
```

#### EXAMPLE 2
```PowerShell
Get-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query 'Select [System.ID] from WorkItems'
```

---
### Parameters
#### **Title**

The Work Item Title



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Query**

A query.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Mine**

Gets work items assigned to me.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **CurrentIteration**

Gets work items in the current iteration.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoDetail**

If set, queries will output the IDs of matching work items.
If not provided, details will be retreived for all work items.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ID**

The Work Item ID



> **Type**: ```[Int32]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Comment**

If set, will get comments related to a work item.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Revision**

If set, will get revisions of a work item.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Update**

If set, will get updates of a work item.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Organization**

The Organization.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Team**

The Team.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **First**

If provided, will only return the first N results from a query.



> **Type**: ```[UInt32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **WorkItemType**

If set, will return work item types.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SharedQuery**

If set, will return work item shared queries



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeDeleted**

If set, will return shared queries that have been deleted.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Depth**

If provided, will return shared queries up to a given depth.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SharedQueryFilter**

If provided, will filter the shared queries returned



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ExpandSharedQuery**

Determines how data from shared queries will be expanded.  By default, expands all data.



Valid Values:

* All
* Clauses
* Minimal
* None
* Wiql



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Field**

One or more fields.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Related**

If set, will get related items



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* PSDevOps.WorkItem




---
### Syntax
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] -ID <Int32> -Organization <String> [-Project <String>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Query] <String> [-Mine] [-CurrentIteration] [-NoDetail] -Organization <String> [-Project <String>] [-Team <String>] [-First <UInt32>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] [-ID <Int32>] -Update -Organization <String> [-Project <String>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] [-ID <Int32>] -Revision -Organization <String> [-Project <String>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] [-ID <Int32>] -Organization <String> [-Project <String>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] -Comment -Organization <String> [-Project <String>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] -Organization <String> [-Project <String>] [-First <UInt32>] -SharedQuery [-IncludeDeleted] [-Depth <Int32>] [-SharedQueryFilter <Int32>] [-ExpandSharedQuery <String>] [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItem [-Title <String>] [-Mine] [-CurrentIteration] -Organization <String> [-Project <String>] -WorkItemType [-Field <String[]>] [-Related] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
