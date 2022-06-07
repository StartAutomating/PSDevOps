
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Project**

The project name or identifier.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |2      |true (ByPropertyName)|
---
#### **AreaPath**

The AreaPath



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |3      |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |4      |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 2.0.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |5      |false        |
---
#### **Depth**

The depth of items to get.  By default, one.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |6      |false        |
---
### Outputs
PSDevOps.AreaPath


---
### Syntax
```PowerShell
Get-ADOAreaPath [-Organization] <String> [-Project] <String> [[-AreaPath] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [[-Depth] <Int32>] [<CommonParameters>]
```
---


