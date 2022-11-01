Get-ADOWiki
-----------
### Synopsis
Gets Azure DevOps Wikis

---
### Description

Gets Azure DevOps Wikis related to a project.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/list)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOWiki -Organization MyOrganization -Project MyProject -PersonalAccessToken $pat
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
#### **Project**

The Project.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **WikiID**

The Wiki Identifier.



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
#### **ApiVersion**

The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* PSDevOps.Wiki




---
### Syntax
```PowerShell
Get-ADOWiki -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOWiki -Organization <String> -Project <String> -WikiID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
