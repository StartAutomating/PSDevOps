
New-ADOPipeline
---------------
### Synopsis
Creates a new ADO Pipeline

---
### Description

Create a new Azure DevOps Pipeline.

---
### Related Links
* [Convert-BuildStep](Convert-BuildStep.md)
* [Import-BuildStep](Import-BuildStep.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
New-ADOPipeline -Trigger SourceChanged -Stage PowerShellStaticAnalysis,TestPowerShellCrossPlatForm, UpdatePowerShellGallery
```

#### EXAMPLE 2
```PowerShell
New-ADOPipeline -Trigger SourceChanged -Stage PowerShellStaticAnalysis,TestPowerShellCrossPlatForm, UpdatePowerShellGallery -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}}
```

---
### Parameters
#### **InputObject**

The InputObject



|Type            |Requried|Postion|PipelineInput |
|----------------|--------|-------|--------------|
|```[PSObject]```|false   |1      |true (ByValue)|
---
#### **UseSystemAccessToken**

If set, will use map the system access token to an environment variable in each script step.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Option**

Optional changes to a part.
A table of additional settings to apply wherever a part is used.
For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |2      |false        |
---
#### **VariableParameter**

The name of parameters that should be supplied from build variables.
Wildcards accepted.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |3      |true (ByPropertyName)|
---
#### **EnvironmentParameter**

The name of parameters that should be supplied from the environment.
Wildcards accepted.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |4      |true (ByPropertyName)|
---
#### **ExcludeParameter**

The name of parameters that should be excluded.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |5      |true (ByPropertyName)|
---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |6      |true (ByPropertyName)|
---
#### **DefaultParameter**

A collection of default parameters.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |7      |true (ByPropertyName)|
---
#### **BuildScript**

A list of build scripts.  Each build script will run as a step in the same job.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |8      |false        |
---
#### **PassThru**

If set, will output the created objects instead of creating YAML.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **PowerShellCore**

If set, will run scripts using PowerShell core, even if on Windows.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **WindowsPowerShell**

If set will run script using WindowsPowerShell if available.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **RootDirectory**

If provided, will directly reference build steps beneath this directory.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |9      |false        |
---
### Outputs
System.String


System.Management.Automation.PSObject


---
### Syntax
```PowerShell
New-ADOPipeline [[-InputObject] <PSObject>] [-UseSystemAccessToken] [[-Option] <IDictionary>] [[-VariableParameter] <String[]>] [[-EnvironmentParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [[-BuildScript] <String[]>] [-PassThru] [-PowerShellCore] [-WindowsPowerShell] [[-RootDirectory] <String>] [<CommonParameters>]
```
---


