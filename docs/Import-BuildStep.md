Import-BuildStep
----------------
### Synopsis
Imports Build Steps

---
### Description

Imports Build Steps defined in a module.

---
### Related Links
* [Convert-BuildStep](Convert-BuildStep.md)



* [Expand-BuildStep](Expand-BuildStep.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Import-BuildStep -ModuleName PSDevOps
```

---
### Parameters
#### **ModuleName**

The name of the module containing build steps.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SourcePath**

The source path.  This path contains definitions for a given single build system.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeCommand**

A list of commands to include.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ExcludeCommand**

A list of commands to exclude



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildSystem**

The different build systems supported.
Each buildsystem is the name of a subdirectory that can contain steps or other components.



Valid Values:

* ADOPipeline
* ADOExtension
* GitHubAction
* GitHubWorkflow



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **BuildSystemAlias**

A list of valid directory aliases for a given build system.
By default, ADOPipelines can exist within a directory named ADOPipeline, ADO, AzDO, or AzureDevOps.
By default, GitHubWorkflows can exist within a directory named GitHubWorkflow, GitHubWorkflows, or GitHub.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **BuildSystemInclude**

> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **BuildCommandType**

> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)




---
### Syntax
```PowerShell
Import-BuildStep -ModuleName <String> [-IncludeCommand <String[]>] [-ExcludeCommand <String[]>] [-BuildSystem <String[]>] [-BuildSystemAlias <IDictionary>] [-BuildSystemInclude <IDictionary>] [-BuildCommandType <IDictionary>] [<CommonParameters>]
```
```PowerShell
Import-BuildStep -SourcePath <String> [-BuildSystem <String[]>] [-BuildSystemAlias <IDictionary>] [-BuildSystemInclude <IDictionary>] [-BuildCommandType <IDictionary>] [<CommonParameters>]
```
---
