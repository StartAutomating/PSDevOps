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
> EXAMPLE 1

```PowerShell
Get-Command Convert-BuildStep | Convert-BuildStep
```

---

### Parameters
#### **Name**
The name of the build step

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **ScriptBlock**
The Script Block that will be converted into a build step

|Type           |Required|Position|PipelineInput                 |
|---------------|--------|--------|------------------------------|
|`[ScriptBlock]`|false   |named   |true (ByValue, ByPropertyName)|

#### **Module**
The module that -ScriptBlock is declared in.  If piping in a command, this will be bound automatically

|Type            |Required|Position|PipelineInput        |
|----------------|--------|--------|---------------------|
|`[PSModuleInfo]`|false   |named   |true (ByPropertyName)|

#### **Path**
The path to the file

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |named   |true (ByPropertyName)|Fullname|

#### **Extension**
The extension of the file

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **InputParameter**
The name of parameters that should be supplied from event input.
Wildcards accepted.

|Type           |Required|Position|PipelineInput        |Aliases        |
|---------------|--------|--------|---------------------|---------------|
|`[IDictionary]`|false   |named   |true (ByPropertyName)|InputParameters|

#### **VariableParameter**
The name of parameters that should be supplied from build variables.
Wildcards accepted.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|VariableParameters|

#### **EnvironmentParameter**
The name of parameters that should be supplied from the environment.
Wildcards accepted.

|Type        |Required|Position|PipelineInput        |Aliases              |
|------------|--------|--------|---------------------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|EnvironmentParameters|

#### **UniqueParameter**
The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.

|Type        |Required|Position|PipelineInput        |Aliases         |
|------------|--------|--------|---------------------|----------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|UniqueParameters|

#### **ExcludeParameter**
The name of parameters that should be excluded.

|Type        |Required|Position|PipelineInput        |Aliases          |
|------------|--------|--------|---------------------|-----------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|ExcludeParameters|

#### **DefaultParameter**
Default parameters for a build step

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[IDictionary]`|false   |named   |true (ByPropertyName)|

#### **BuildSystem**
The build system.  Currently supported options, ADO and GitHub.  Defaulting to ADO.
Valid Values:

* ADOPipeline
* ADOExtension
* GitHubWorkflow
* GitHubAction

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **BuildOption**
Options for the build system.  The can contain any additional parameters passed to the build system.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[PSObject]`|false   |named   |false        |

---

### Outputs
* [Collections.IDictionary](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.IDictionary)

---

### Syntax
```PowerShell
Convert-BuildStep -Name <String> [-ScriptBlock <ScriptBlock>] [-Module <PSModuleInfo>] [-Path <String>] [-InputParameter <IDictionary>] [-VariableParameter <String[]>] [-EnvironmentParameter <String[]>] [-UniqueParameter <String[]>] [-ExcludeParameter <String[]>] [-DefaultParameter <IDictionary>] [-BuildSystem <String>] [-BuildOption <PSObject>] [<CommonParameters>]
```
```PowerShell
Convert-BuildStep -Name <String> -Path <String> -Extension <String> [-InputParameter <IDictionary>] [-VariableParameter <String[]>] [-EnvironmentParameter <String[]>] [-UniqueParameter <String[]>] [-ExcludeParameter <String[]>] [-DefaultParameter <IDictionary>] [-BuildSystem <String>] [-BuildOption <PSObject>] [<CommonParameters>]
```
