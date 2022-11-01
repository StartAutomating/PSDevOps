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



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **UseSystemAccessToken**

If set, will use map the system access token to an environment variable in each script step.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Option**

Optional changes to a part.
A table of additional settings to apply wherever a part is used.
For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **VariableParameter**

The name of parameters that should be supplied from build variables.
Wildcards accepted.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **EnvironmentParameter**

The name of parameters that should be supplied from the environment.
Wildcards accepted.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **ExcludeParameter**

The name of parameters that should be excluded.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **DefaultParameter**

A collection of default parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildScript**

A list of build scripts.  Each build script will run as a step in the same job.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:false



---
#### **PassThru**

If set, will output the created objects instead of creating YAML.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **PowerShellCore**

If set, will run scripts using PowerShell core, even if on Windows.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **WindowsPowerShell**

If set will run script using WindowsPowerShell if available.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **RootDirectory**

If provided, will directly reference build steps beneath this directory.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:false



---
#### **OutputPath**

If provided, will output to a given path and return a file.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 10

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)


* [Management.Automation.PSObject](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSObject)


* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)




---
### Syntax
```PowerShell
New-ADOPipeline [[-InputObject] <PSObject>] [-UseSystemAccessToken] [[-Option] <IDictionary>] [[-VariableParameter] <String[]>] [[-EnvironmentParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [[-BuildScript] <String[]>] [-PassThru] [-PowerShellCore] [-WindowsPowerShell] [[-RootDirectory] <String>] [[-OutputPath] <String>] [<CommonParameters>]
```
---
