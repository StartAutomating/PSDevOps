
Trace-ADOCommand
----------------
### Synopsis
Traces information about commands run in Azure DevOps

---
### Description

Traces information a command line into the output of Azure DevOps.

---
### Related Links
* [Write-ADOCommand](Write-ADOCommand.md)
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)
---
### Examples
#### EXAMPLE 1
```PowerShell
Trace-ADOCommand -Command Get-Process -Parameter @{id=$pid}
```

#### EXAMPLE 2
```PowerShell
$myInvocation | Trace-ADOCommand
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
Trace-ADOCommand -Command <String> [-Parameter <IDictionary>] [<CommonParameters>]
```
---


