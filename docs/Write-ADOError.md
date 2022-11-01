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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **SourcePath**

An optional source path.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **LineNumber**

An optional line number.



> **Type**: ```[UInt32]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **ColumnNumber**

An optional column number.



> **Type**: ```[UInt32]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **Code**

An optional error code.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Write-ADOError [-Message] <String> [[-SourcePath] <String>] [[-LineNumber] <UInt32>] [[-ColumnNumber] <UInt32>] [[-Code] <String>] [<CommonParameters>]
```
---
