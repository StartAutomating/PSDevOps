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
> EXAMPLE 1

```PowerShell
Import-BuildStep -ModuleName PSDevOps
```

---

### Parameters
#### **ModuleName**
The name of the module containing build steps.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|Name   |

#### **SourcePath**
The source path.  This path contains definitions for a given single build system.

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|true    |named   |true (ByPropertyName)|Fullname|

#### **SourceFile**
The source path to a single item.

|Type      |Required|Position|PipelineInput        |Aliases                             |
|----------|--------|--------|---------------------|------------------------------------|
|`[String]`|true    |named   |true (ByPropertyName)|ScriptFile<br/>ScriptPath<br/>Source|

#### **BuildStepType**
The type the source file will be in a given build system.  By default, step.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **BuildStepName**
An optional name for the build step.  If none is provided, the filename will be used

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **IncludeCommand**
A list of commands to include.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **ExcludeCommand**
A list of commands to exclude

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **BuildSystem**
The different build systems supported.
Each buildsystem is the name of a subdirectory that can contain steps or other components.
Valid Values:

* ADOPipeline
* ADOExtension
* GitHubAction
* GitHubWorkflow

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **BuildSystemAlias**
A list of valid directory aliases for a given build system.
By default, ADOPipelines can exist within a directory named ADOPipeline, ADO, AzDO, or AzureDevOps.
By default, GitHubWorkflows can exist within a directory named GitHubWorkflow, GitHubWorkflows, or GitHub.

|Type           |Required|Position|PipelineInput|Aliases           |
|---------------|--------|--------|-------------|------------------|
|`[IDictionary]`|false   |named   |false        |BuildSystemAliases|

#### **BuildSystemInclude**

|Type           |Required|Position|PipelineInput|Aliases            |
|---------------|--------|--------|-------------|-------------------|
|`[IDictionary]`|false   |named   |false        |BuildSystemIncludes|

#### **BuildCommandType**

|Type           |Required|Position|PipelineInput|Aliases          |
|---------------|--------|--------|-------------|-----------------|
|`[IDictionary]`|false   |named   |false        |BuildCommandTypes|

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
```PowerShell
Import-BuildStep -SourceFile <String> [-BuildStepType <String>] [-BuildStepName <String>] [-BuildSystem <String[]>] [-BuildSystemAlias <IDictionary>] [-BuildSystemInclude <IDictionary>] [-BuildCommandType <IDictionary>] [<CommonParameters>]
```
