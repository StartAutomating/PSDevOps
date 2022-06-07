
Write-ADOError
--------------
### Synopsis
Writes an ADO Error

---
### Description

Writes an Azure DevOps Error

---
### Related Links
* [Write-ADOWarning](Write-ADOWarning.md)
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)
---
### Examples
#### EXAMPLE 1
```PowerShell
Write-ADOError "Stuff hit the fan"
```

---
### Parameters
#### **Message**

The error message.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **SourcePath**

An optional source path.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **LineNumber**

An optional line number.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[UInt32]```|false   |3      |true (ByPropertyName)|
---
#### **ColumnNumber**

An optional column number.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[UInt32]```|false   |4      |true (ByPropertyName)|
---
#### **Code**

An optional error code.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |5      |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Write-ADOError [-Message] <String> [[-SourcePath] <String>] [[-LineNumber] <UInt32>] [[-ColumnNumber] <UInt32>] [[-Code] <String>] [<CommonParameters>]
```
---


