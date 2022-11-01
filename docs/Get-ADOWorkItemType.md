Get-ADOWorkItemType
-------------------
### Synopsis
Gets work item types

---
### Description

Gets work item types from Azure DevOps

---
### Related Links
* [Get-ADOWorkProcess](Get-ADOWorkProcess.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOWorkProcess -Organization StartAutomating -Project PSDevOps |
    Get-ADOWorkItemType
```

#### EXAMPLE 2
```PowerShell
Get-ADOWorkItemType -Organization StartAutomating -Icon
```

#### EXAMPLE 3
```PowerShell
Get-ADOWorkItemType -Organization StartAutomating -Project PSDevOps
```

---
### Parameters
#### **Organization**

The Organization.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProcessID**

The ProcessID.  This is returned from Get-ADOWorkProcess.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ReferenceName**

The Reference Name of the Work Item Type.  This can be provided by piping Get-ADOWorkItemType to itself.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Layout**

If set, will get the layout associated with a given work item type.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Page**

If set, will get the pages within a given work item type layout.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **State**

If set, will get the states associated with a given work item type.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Rule**

If set, will get the rules associated with a given work item type.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Behavior**

If set, will get the behaviors associated with a given work item type.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Field**

If set,  will get the fields associated with a given work item type.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Project**

The name of the project.  If provided, will get work item type information related to the project.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Icon**

If set, will get work item icons available to the organization.



> **Type**: ```[Switch]```

> **Required**: true

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
* PSDevOps.WorkItemType


* PSDevOps.State


* PSDevOps.Rule


* PSDevOps.Behavior


* PSDevOps.Layout


* PSDevOps.ProcessField




---
### Syntax
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> -ReferenceName <String> -Behavior [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> -ReferenceName <String> -Field [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> -ReferenceName <String> -Rule [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> -ReferenceName <String> -State [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> -ReferenceName <String> -Layout [-Page] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> -ReferenceName <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -ProcessID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWorkItemType -Organization <String> -Icon [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
