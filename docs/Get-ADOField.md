Get-ADOField
------------
### Synopsis
Gets fields from Azure DevOps

---
### Description

Gets fields from Azure DevOps or Team Foundation Server.

---
### Related Links
* [New-ADOField](New-ADOField.md)



* [Remove-ADOField](Remove-ADOField.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/fields/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/fields/list)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOField -Organization StartAutomating -Project PSDevOps
```

---
### Parameters
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FieldName**

The name of the field.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProcessID**

The processs identifier.  This is used to get field information related to a particular work process template.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **WorkItemTypeName**

The name of the work item type.  This is used to get field information related to a particular work process template.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

If set, will force a refresh of the cached results.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



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
* PSDevOps.Field




---
### Syntax
```PowerShell
Get-ADOField -Organization <String> [-Project <String>] [-FieldName <String>] [-Server <Uri>] [-Force] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOField -Organization <String> [-Project <String>] [-FieldName <String>] -ProcessID <String> -WorkItemTypeName <String> [-Server <Uri>] [-Force] [-ApiVersion <String>] [<CommonParameters>]
```
---
