
Import-ADOProxy
---------------
### Synopsis
Imports an Azure DevOps Proxy

---
### Description

Imports a Proxy Module for Azure DevOps or TFS.

A Proxy module will wrap all commands, but will always provide one or more default parameters.

---
### Related Links
* [Connect-ADO](Connect-ADO.md)
* [Disconnect-ADO](Disconnect-ADO.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Import-ADOProxy -Organization StartAutomating
```

#### EXAMPLE 2
```PowerShell
Import-ADOProxy -Organization StartAutomating -Prefix SA
```

#### EXAMPLE 3
```PowerShell
Import-ADOProxy -Organization StartAutomating -Project PSDevOps -IncludeCommand *Build* -Prefix SADO
```

---
### Parameters
#### **Organization**

The Organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Project**

The project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **Server**

The server.  This can be used to provide a TFS instance



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |3      |true (ByPropertyName)|
---
#### **Prefix**

The prefix for all commands in the proxy module.
If not provided, this will be the -Server + -Organization + -Project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |4      |true (ByPropertyName)|
---
#### **IncludeCommand**

A list of command wildcards to include.  By default, all applicable commands.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |5      |true (ByPropertyName)|
---
#### **ExcludeCommand**

A list of commands to exclude.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |6      |true (ByPropertyName)|
---
#### **PassThru**

If set, will return the imported module.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Force**

If set, will unload a previously loaded copy of the module.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Outputs
System.Nullable


System.Management.Automation.PSModuleInfo


---
### Syntax
```PowerShell
Import-ADOProxy [-Organization] <String> [[-Project] <String>] [[-Server] <Uri>] [[-Prefix] <String>] [[-IncludeCommand] <String[]>] [[-ExcludeCommand] <String[]>] [-PassThru] [-Force] [<CommonParameters>]
```
---


