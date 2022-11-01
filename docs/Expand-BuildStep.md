Expand-BuildStep
----------------
### Synopsis
Expands Build Steps in a single build object

---
### Description

Component Files are .ps1 or datafiles within a directory that tells you what type they are.

---
### Related Links
* [Convert-BuildStep](Convert-BuildStep.md)



* [Import-BuildStep](Import-BuildStep.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Expand-BuildStep -StepMap @{Steps='InstallPester','RunPester'}
```

---
### Parameters
#### **StepMap**

A map of step properties to underlying data.
Each key is the name of a property the output.
Each value may contain the name of another Step or StepMap



> **Type**: ```[IDictionary]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **Parent**

The immediate parent object



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **Root**

The absolute root object



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
#### **Singleton**

If set, the component will be expanded as a singleton (single object)



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **SingleItemName**

A list of item names that automatically become singletons



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **PluralItemName**

A list of item names that automatically become plurals



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **DictionaryItemName**

A list of item names that automatically become dictionaries.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
#### **BuildSystem**

The build system, either ADO or GitHub.



Valid Values:

* ADOPipeline
* ADOExtension
* GitHubWorkflow
* GitHubAction



> **Type**: ```[String]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:false



---
#### **VariableParameter**

The name of parameters that should be supplied from build variables.
Wildcards accepted.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **InputParameter**

The name of parameters that should be supplied from webhook events.
Wildcards accepted.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:true (ByPropertyName)



---
#### **EnvironmentParameter**

The name of parameters that should be supplied from the environment.
Wildcards accepted.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 10

> **PipelineInput**:true (ByPropertyName)



---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 11

> **PipelineInput**:true (ByPropertyName)



---
#### **ExcludeParameter**

The name of parameters that should be excluded.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 12

> **PipelineInput**:true (ByPropertyName)



---
#### **DefaultParameter**

A collection of default parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 13

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildOption**

Options for the build system.  The can contain any additional parameters passed to the build system.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 14

> **PipelineInput**:false



---
### Outputs
* [Management.Automation.PSObject](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSObject)




---
### Syntax
```PowerShell
Expand-BuildStep [-StepMap] <IDictionary> [[-Parent] <PSObject>] [[-Root] <PSObject>] [-Singleton] [[-SingleItemName] <String[]>] [[-PluralItemName] <String[]>] [[-DictionaryItemName] <String[]>] [[-BuildSystem] <String>] [[-VariableParameter] <String[]>] [[-InputParameter] <IDictionary>] [[-EnvironmentParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [[-BuildOption] <PSObject>] [<CommonParameters>]
```
---
