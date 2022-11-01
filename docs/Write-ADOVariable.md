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
#### EXAMPLE 1
```PowerShell
Write-ADOVariable -Name Sauce -Value "Crushed Tomatoes"
```

---
### Parameters
#### **Name**

The variable name.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Value**

The variable value.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **IsSecret**

If set, the variable will be a secret.  Secret variables will not echo in logs.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IsReadOnly**

If set, the variable will be marked as read only.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IsOutput**

If set, the variable will be marked as output.  Output variables may be referenced in subsequent steps of the same job.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Write-ADOVariable [-Name] <String> [[-Value] <PSObject>] [-IsSecret] [-IsReadOnly] [-IsOutput] [<CommonParameters>]
```
---
