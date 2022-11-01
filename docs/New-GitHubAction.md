New-GitHubAction
----------------
### Synopsis
Creates a new GitHub action

---
### Description
---
### Related Links
* [New-GitHubWorkflow](New-GitHubWorkflow.md)



* [Import-BuildStep](Import-BuildStep.md)



* [Convert-BuildStep](Convert-BuildStep.md)



* [Expand-BuildStep](Expand-BuildStep.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
New-GitHubAction -Job TestPowerShellOnLinux
```

---
### Parameters
#### **Name**

The name of the action.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **Description**

A description of the action.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **Action**

The git hub action steps.
While we don't want to restrict the steps here, we _do_ want to be able to suggest steps that are built-in.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DockerImage**

The DockerImage used for a GitHub Action.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NodeJSScript**

The NodeJS main script used for a GitHub Action.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ActionInput**

The git hub action inputs.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ActionOutput**

The git hub action outputs.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Option**

Optional changes to a component.
A table of additional settings to apply wherever a part is used.
For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExcludeParameter**

The name of parameters that should be excluded.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **UniqueParameter**

The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DefaultParameter**

A collection of default parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

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

A list of build scripts.  Each build script will run as a step in the action.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Icon**

The icon used for branding.  By default, a terminal icon.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Color**

The color used for branding.  By default, blue.



Valid Values:

* white
* yellow
* blue
* green
* orange
* red
* purple
* gray-dark



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **OutputPath**

If provided, will output to a given path and return a file.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
New-GitHubAction [-Name] <String> [-Description] <String> [-Action <PSObject[]>] [-DockerImage <String>] [-NodeJSScript <String>] [-ActionInput <IDictionary>] [-ActionOutput <IDictionary>] [-Option <IDictionary>] [-ExcludeParameter <String[]>] [-UniqueParameter <String[]>] [-DefaultParameter <IDictionary>] [-PassThru] [-BuildScript <String[]>] [-Icon <String>] [-Color <String>] [-OutputPath <String>] [<CommonParameters>]
```
---
