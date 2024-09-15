Trace-GitHubCommand
-------------------

### Synopsis
Traces information into GitHub Workflow Output

---

### Description

Traces information about a command as a debug message in a GitHub workflow.

---

### Related Links
* [Write-GitDebug](Write-GitDebug.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Trace-GitHubCommand -Command Get-Process -Parameter @{id=$pid}
```
> EXAMPLE 2

```PowerShell
$myInvocation | Trace-GitHubCommand
```

---

### Parameters
#### **Command**
The command line.

|Type      |Required|Position|PipelineInput        |Aliases           |
|----------|--------|--------|---------------------|------------------|
|`[String]`|true    |named   |true (ByPropertyName)|MyCommand<br/>Line|

#### **Parameter**
A dictionary of parameters to the command.

|Type           |Required|Position|PipelineInput        |Aliases                       |
|---------------|--------|--------|---------------------|------------------------------|
|`[IDictionary]`|false   |named   |true (ByPropertyName)|Parameters<br/>BoundParameters|

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Trace-GitHubCommand -Command <String> [-Parameter <IDictionary>] [<CommonParameters>]
```
