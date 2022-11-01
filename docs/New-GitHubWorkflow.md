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



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Name**

The name of the workflow.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **Option**

Optional changes to a component.
A table of additional settings to apply wherever a part is used.
For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
#### **Environment**

A collection of environment variables used throughout the build.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **InputParameter**

The name of parameters that should be supplied from an event.
Wildcards accepted.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **VariableParameter**

The name of parameters that should be supplied from build variables.
Wildcards accepted.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **ExcludeParameter**

The name of parameters that should be excluded.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **DefaultParameter**

A collection of default parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:true (ByPropertyName)



---
#### **PassThru**

If set, will output the created objects instead of creating YAML.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **BuildScript**

A list of build scripts.  Each build script will run as a step in the same job.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 10

> **PipelineInput**:false



---
#### **RootDirectory**

If provided, will directly reference build steps beneath this directory.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 11

> **PipelineInput**:false



---
#### **OutputPath**

If provided, will output to a given path and return a file.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 12

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
New-GitHubWorkflow [[-InputObject] <PSObject>] [[-Name] <String>] [[-Option] <IDictionary>] [[-Environment] <IDictionary>] [[-InputParameter] <IDictionary>] [[-VariableParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [-PassThru] [[-BuildScript] <String[]>] [[-RootDirectory] <String>] [[-OutputPath] <String>] [<CommonParameters>]
```
---
