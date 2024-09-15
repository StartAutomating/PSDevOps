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
> EXAMPLE 1

```PowerShell
New-GitHubWorkflow -Job TestPowerShellOnLinux
```

---

### Parameters
#### **InputObject**
The input object.

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |1       |true (ByValue)|

#### **Name**
The name of the workflow.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

#### **Option**
Optional changes to a component.
A table of additional settings to apply wherever a part is used.
For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |3       |false        |

#### **Environment**
A collection of environment variables used throughout the build.

|Type           |Required|Position|PipelineInput        |Aliases|
|---------------|--------|--------|---------------------|-------|
|`[IDictionary]`|false   |4       |true (ByPropertyName)|Env    |

#### **InputParameter**
The name of parameters that should be supplied from an event.
Wildcards accepted.

|Type           |Required|Position|PipelineInput        |Aliases        |
|---------------|--------|--------|---------------------|---------------|
|`[IDictionary]`|false   |5       |true (ByPropertyName)|InputParameters|

#### **VariableParameter**
The name of parameters that should be supplied from build variables.
Wildcards accepted.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |6       |true (ByPropertyName)|VariableParameters|

#### **ExcludeParameter**
The name of parameters that should be excluded.

|Type        |Required|Position|PipelineInput        |Aliases          |
|------------|--------|--------|---------------------|-----------------|
|`[String[]]`|false   |7       |true (ByPropertyName)|ExcludeParameters|

#### **UniqueParameter**
The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.

|Type        |Required|Position|PipelineInput        |Aliases         |
|------------|--------|--------|---------------------|----------------|
|`[String[]]`|false   |8       |true (ByPropertyName)|UniqueParameters|

#### **DefaultParameter**
A collection of default parameters.

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[IDictionary]`|false   |9       |true (ByPropertyName)|

#### **PassThru**
If set, will output the created objects instead of creating YAML.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **BuildScript**
A list of build scripts.  Each build script will run as a step in the same job.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |10      |false        |

#### **RootDirectory**
If provided, will directly reference build steps beneath this directory.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |11      |false        |

#### **OutputPath**
If provided, will output to a given path and return a file.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |12      |false        |

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
New-GitHubWorkflow [[-InputObject] <PSObject>] [[-Name] <String>] [[-Option] <IDictionary>] [[-Environment] <IDictionary>] [[-InputParameter] <IDictionary>] [[-VariableParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [-PassThru] [[-BuildScript] <String[]>] [[-RootDirectory] <String>] [[-OutputPath] <String>] [<CommonParameters>]
```
