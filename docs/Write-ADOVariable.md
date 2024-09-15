Write-ADOVariable
-----------------

### Synopsis
Writes an ADO Variable

---

### Description

Writes a Azure DevOps Variable.

---

### Related Links
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)

---

### Examples
> EXAMPLE 1

```PowerShell
Write-ADOVariable -Name Sauce -Value "Crushed Tomatoes"
```

---

### Parameters
#### **Name**
The variable name.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|

#### **Value**
The variable value.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |2       |true (ByPropertyName)|

#### **IsSecret**
If set, the variable will be a secret.  Secret variables will not echo in logs.

|Type      |Required|Position|PipelineInput|Aliases          |
|----------|--------|--------|-------------|-----------------|
|`[Switch]`|false   |named   |false        |IsSafe<br/>Secret|

#### **IsReadOnly**
If set, the variable will be marked as read only.

|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|false   |named   |false        |ReadOnly|

#### **IsOutput**
If set, the variable will be marked as output.  Output variables may be referenced in subsequent steps of the same job.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Output |

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Write-ADOVariable [-Name] <String> [[-Value] <PSObject>] [-IsSecret] [-IsReadOnly] [-IsOutput] [<CommonParameters>]
```
