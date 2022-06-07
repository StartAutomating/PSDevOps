
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
#### EXAMPLE 1
```PowerShell
Trace-GitHubCommand -Command Get-Process -Parameter @{id=$pid}
```

#### EXAMPLE 2
```PowerShell
$myInvocation | Trace-GitHubCommand
```

---
### Parameters
#### **Command**

The command line.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Parameter**

A dictionary of parameters to the command.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |named  |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Trace-GitHubCommand -Command <String> [-Parameter <IDictionary>] [<CommonParameters>]
```
---


