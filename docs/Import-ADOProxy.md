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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The project.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  This can be used to provide a TFS instance



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Prefix**

The prefix for all commands in the proxy module.
If not provided, this will be the -Server + -Organization + -Project.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeCommand**

A list of command wildcards to include.  By default, all applicable commands.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **ExcludeCommand**

A list of commands to exclude.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **PassThru**

If set, will return the imported module.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Force**

If set, will unload a previously loaded copy of the module.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)


* [Management.Automation.PSModuleInfo](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSModuleInfo)




---
### Syntax
```PowerShell
Import-ADOProxy [-Organization] <String> [[-Project] <String>] [[-Server] <Uri>] [[-Prefix] <String>] [[-IncludeCommand] <String[]>] [[-ExcludeCommand] <String[]>] [-PassThru] [-Force] [<CommonParameters>]
```
---
