
New-GitHubWorkflow
------------------
### Synopsis
Creates a new GitHub Workflow

---
### Description
---
### Related Links
* [Import-BuildStep](Import-BuildStep.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
New-GitHubWorkflow -Job TestPowerShellOnLinux
```

---
### Parameters
#### **InputObject**

The input object.



|Type            |Requried|Postion|PipelineInput |
|----------------|--------|-------|--------------|
|```[PSObject]```|false   |1      |true (ByValue)|
---
#### **Name**

The name of the workflow.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |2      |false        |
---
#### **Option**

Optional changes to a component.
A table of additional settings to apply wherever a part is used.
For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |3      |false        |
---
#### **Environment**

A collection of environment variables used throughout the build.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |4      |true (ByPropertyName)|
---
#### **InputParameter**

The name of parameters that should be supplied from an event.
Wildcards accepted.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |5      |true (ByPropertyName)|
---
#### **VariableParameter**

The name of parameters that should be supplied from build variables.
Wildcards accepted.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |6      |true (ByPropertyName)|
---
#### **ExcludeParameter**

The name of parameters that should be excluded.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |7      |true (ByPropertyName)|
---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |8      |true (ByPropertyName)|
---
#### **DefaultParameter**

A collection of default parameters.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |9      |true (ByPropertyName)|
---
#### **PassThru**

If set, will output the created objects instead of creating YAML.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **BuildScript**

A list of build scripts.  Each build script will run as a step in the same job.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |10     |false        |
---
#### **RootDirectory**

|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |11     |false        |
---
### Outputs
System.String


---
### Syntax
```PowerShell
New-GitHubWorkflow [[-InputObject] <PSObject>] [[-Name] <String>] [[-Option] <IDictionary>] [[-Environment] <IDictionary>] [[-InputParameter] <IDictionary>] [[-VariableParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [-PassThru] [[-BuildScript] <String[]>] [[-RootDirectory] <String>] [<CommonParameters>]
```
---


