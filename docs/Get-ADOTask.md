
Get-ADOTask
-----------
### Synopsis
Gets Azure DevOps Tasks

---
### Description

Gets Tasks and Task Groups from Azure DevOps

---
### Related Links
* [Convert-ADOPipeline](Convert-ADOPipeline.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOTask -Organization StartAutomating
```

#### EXAMPLE 2
```PowerShell
Get-ADOTask -Organization StartAutomating -YAMLSchema
```

---
### Parameters
#### **Organization**

The organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Project**

The project.  Required to get task groups.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **TaskGroup**

If set, will get task groups related to a project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **YAMLSchema**

If set, will get the schema for YAML tasks within an organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |named  |true (ByPropertyName)|
---
### Outputs
PSDevOps.Task


---
### Syntax
```PowerShell
Get-ADOTask -Organization <String> [-Server <Uri>] [<CommonParameters>]
```
```PowerShell
Get-ADOTask -Organization <String> -Project <String> -TaskGroup [-Server <Uri>] [<CommonParameters>]
```
```PowerShell
Get-ADOTask -Organization <String> -YAMLSchema [-Server <Uri>] [<CommonParameters>]
```
---


