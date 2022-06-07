
Write-ADOWarning
----------------
### Synopsis
Writes an ADO Warning

---
### Description

Writes an Azure DevOps Warning

---
### Related Links
* [Write-ADOError](Write-ADOError.md)
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)
---
### Examples
#### EXAMPLE 1
```PowerShell
Write-ADOWarning "Stuff hit the fan"
```

---
### Parameters
#### **Message**

The Warning message.



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

An optional Warning code.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |5      |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Write-ADOWarning [-Message] <String> [[-SourcePath] <String>] [[-LineNumber] <UInt32>] [[-ColumnNumber] <UInt32>] [[-Code] <String>] [<CommonParameters>]
```
---


