
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **SourcePath**

The source path.  This path contains definitions for a given single build system.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **IncludeCommand**

A list of commands to include.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **ExcludeCommand**

A list of commands to exclude



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **BuildSystem**

The different build systems supported.
Each buildsystem is the name of a subdirectory that can contain steps or other components.



Valid Values:

* ADOPipeline
* ADOExtension
* GitHubAction
* GitHubWorkflow
|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |named  |false        |
---
#### **BuildSystemAlias**

A list of valid directory aliases for a given build system.
By default, ADOPipelines can exist within a directory named ADOPipeline, ADO, AzDO, or AzureDevOps.
By default, GitHubWorkflows can exist within a directory named GitHubWorkflow, GitHubWorkflows, or GitHub.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |named  |false        |
---
#### **BuildSystemInclude**

|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |named  |false        |
---
#### **BuildCommandType**

|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |named  |false        |
---
### Outputs
System.Nullable


---
### Syntax
```PowerShell
Import-BuildStep -ModuleName <String> [-IncludeCommand <String[]>] [-ExcludeCommand <String[]>] [-BuildSystem <String[]>] [-BuildSystemAlias <IDictionary>] [-BuildSystemInclude <IDictionary>] [-BuildCommandType <IDictionary>] [<CommonParameters>]
```
```PowerShell
Import-BuildStep -SourcePath <String> [-BuildSystem <String[]>] [-BuildSystemAlias <IDictionary>] [-BuildSystemInclude <IDictionary>] [-BuildCommandType <IDictionary>] [<CommonParameters>]
```
---


