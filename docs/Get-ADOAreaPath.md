Get-ADOAreaPath
---------------
### Synopsis
Gets area paths

---
### Description

Get area paths from Azure DevOps

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/Classification%20Nodes/Get%20Classification%20Nodes?view=azure-devops-rest-5.1#get-the-root-area-tree](https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/Classification%20Nodes/Get%20Classification%20Nodes?view=azure-devops-rest-5.1#get-the-root-area-tree)



* [Add-ADOAreaPath](Add-ADOAreaPath.md)



* [Remove-ADOAreaPath](Remove-ADOAreaPath.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOAreaPath -Organization StartAutomating -Project PSDevOps
```

---
### Parameters
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The project name or identifier.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **AreaPath**

The AreaPath



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 2.0.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **Depth**

The depth of items to get.  By default, one.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
### Outputs
* PSDevOps.AreaPath




---
### Syntax
```PowerShell
Get-ADOAreaPath [-Organization] <String> [-Project] <String> [[-AreaPath] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [[-Depth] <Int32>] [<CommonParameters>]
```
---
