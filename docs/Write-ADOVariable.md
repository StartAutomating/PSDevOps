
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Value**

The variable value.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |2      |true (ByPropertyName)|
---
#### **IsSecret**

If set, the variable will be a secret.  Secret variables will not echo in logs.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **IsReadOnly**

If set, the variable will be marked as read only.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **IsOutput**

If set, the variable will be marked as output.  Output variables may be referenced in subsequent steps of the same job.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Outputs
System.String


---
### Syntax
```PowerShell
Write-ADOVariable [-Name] <String> [[-Value] <PSObject>] [-IsSecret] [-IsReadOnly] [-IsOutput] [<CommonParameters>]
```
---


