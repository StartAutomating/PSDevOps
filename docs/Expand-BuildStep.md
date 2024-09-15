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
> EXAMPLE 1

```PowerShell
Expand-BuildStep -StepMap @{Steps='InstallPester','RunPester'}
```

---

### Parameters
#### **StepMap**
A map of step properties to underlying data.
Each key is the name of a property the output.
Each value may contain the name of another Step or StepMap

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|true    |1       |false        |

#### **Parent**
The immediate parent object

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[PSObject]`|false   |2       |false        |

#### **Root**
The absolute root object

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[PSObject]`|false   |3       |false        |

#### **Singleton**
If set, the component will be expanded as a singleton (single object)

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **SingleItemName**
A list of item names that automatically become singletons

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |4       |false        |

#### **PluralItemName**
A list of item names that automatically become plurals

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |5       |false        |

#### **DictionaryItemName**
A list of item names that automatically become dictionaries.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |6       |false        |

#### **BuildSystem**
The build system, either ADO or GitHub.
Valid Values:

* ADOPipeline
* ADOExtension
* GitHubWorkflow
* GitHubAction

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |7       |false        |

#### **VariableParameter**
The name of parameters that should be supplied from build variables.
Wildcards accepted.

|Type        |Required|Position|PipelineInput        |Aliases           |
|------------|--------|--------|---------------------|------------------|
|`[String[]]`|false   |8       |true (ByPropertyName)|VariableParameters|

#### **InputParameter**
The name of parameters that should be supplied from webhook events.
Wildcards accepted.

|Type           |Required|Position|PipelineInput        |Aliases        |
|---------------|--------|--------|---------------------|---------------|
|`[IDictionary]`|false   |9       |true (ByPropertyName)|InputParameters|

#### **EnvironmentParameter**
The name of parameters that should be supplied from the environment.
Wildcards accepted.

|Type        |Required|Position|PipelineInput        |Aliases              |
|------------|--------|--------|---------------------|---------------------|
|`[String[]]`|false   |10      |true (ByPropertyName)|EnvironmentParameters|

#### **UniqueParameter**
The name of parameters that should be referred to uniquely.
For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
The build parameter would be foo_bar.

|Type        |Required|Position|PipelineInput        |Aliases         |
|------------|--------|--------|---------------------|----------------|
|`[String[]]`|false   |11      |true (ByPropertyName)|UniqueParameters|

#### **ExcludeParameter**
The name of parameters that should be excluded.

|Type        |Required|Position|PipelineInput        |Aliases          |
|------------|--------|--------|---------------------|-----------------|
|`[String[]]`|false   |12      |true (ByPropertyName)|ExcludeParameters|

#### **DefaultParameter**
A collection of default parameters.

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[IDictionary]`|false   |13      |true (ByPropertyName)|

#### **BuildOption**
Options for the build system.  The can contain any additional parameters passed to the build system.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[PSObject]`|false   |14      |false        |

---

### Outputs
* [Management.Automation.PSObject](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSObject)

---

### Syntax
```PowerShell
Expand-BuildStep [-StepMap] <IDictionary> [[-Parent] <PSObject>] [[-Root] <PSObject>] [-Singleton] [[-SingleItemName] <String[]>] [[-PluralItemName] <String[]>] [[-DictionaryItemName] <String[]>] [[-BuildSystem] <String>] [[-VariableParameter] <String[]>] [[-InputParameter] <IDictionary>] [[-EnvironmentParameter] <String[]>] [[-UniqueParameter] <String[]>] [[-ExcludeParameter] <String[]>] [[-DefaultParameter] <IDictionary>] [[-BuildOption] <PSObject>] [<CommonParameters>]
```
