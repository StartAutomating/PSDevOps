
Convert-BuildStep
-----------------
### Synopsis
Converts Build Steps into build system input

---
### Description

Converts Build Steps defined in a PowerShell script into build steps in a build system

---
### Related Links
* [Import-BuildStep](Import-BuildStep.md)
* [Expand-BuildStep](Expand-BuildStep.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-Command Convert-BuildStep | Convert-BuildStep
```

---
### Parameters
#### **Name**

The name of the build step



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ScriptBlock**

The Script Block that will be converted into a build step



|Type               |Requried|Postion|PipelineInput                 |
|-------------------|--------|-------|------------------------------|
|```[ScriptBlock]```|false   |named  |true (ByValue, ByPropertyName)|
---
#### **Module**

The module that -ScriptBlock is declared in.  If piping in a command, this will be bound automatically



|Type                |Requried|Postion|PipelineInput        |
|--------------------|--------|-------|---------------------|
|```[PSModuleInfo]```|false   |named  |true (ByPropertyName)|
---
#### **Path**

The path to the file



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Extension**

The extension of the file



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **InputParameter**

The name of parameters that should be supplied from event input.
Wildcards accepted.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |named  |true (ByPropertyName)|
---
#### **VariableParameter**

The name of parameters that should be supplied from build variables.
Wildcards accepted.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **EnvironmentParameter**

The name of parameters that should be supplied from the environment.
Wildcards accepted.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **ExcludeParameter**

The name of parameters that should be excluded.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **DefaultParameter**

Default parameters for a build step



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |named  |true (ByPropertyName)|
---
#### **BuildSystem**

The build system.  Currently supported options, ADO and GitHub.  Defaulting to ADO.



Valid Values:

* ADOPipeline
* ADOExtension
* GitHubWorkflow
* GitHubAction
|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **BuildOption**

Options for the build system.  The can contain any additional parameters passed to the build system.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[PSObject]```|false   |named  |false        |
---
### Outputs
System.Collections.IDictionary


---
### Syntax
```PowerShell
Convert-BuildStep -Name <String> [-ScriptBlock <ScriptBlock>] [-Module <PSModuleInfo>] [-Path <String>] [-InputParameter <IDictionary>] [-VariableParameter <String[]>] [-EnvironmentParameter <String[]>] [-UniqueParameter <String[]>] [-ExcludeParameter <String[]>] [-DefaultParameter <IDictionary>] [-BuildSystem <String>] [-BuildOption <PSObject>] [<CommonParameters>]
```
```PowerShell
Convert-BuildStep -Name <String> -Path <String> -Extension <String> [-InputParameter <IDictionary>] [-VariableParameter <String[]>] [-EnvironmentParameter <String[]>] [-UniqueParameter <String[]>] [-ExcludeParameter <String[]>] [-DefaultParameter <IDictionary>] [-BuildSystem <String>] [-BuildOption <PSObject>] [<CommonParameters>]
```
---


