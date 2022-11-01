Write-ADODebug
--------------
### Synopsis
Writes an ADO Debug

---
### Description

Writes an Azure DevOps Debug

---
### Related Links
* [Write-ADOError](Write-ADOError.md)



* [Write-ADOWarning](Write-ADOWarning.md)



* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)



---
### Examples
#### EXAMPLE 1
```PowerShell
Write-ADODebug "Some extra information"
```

---
### Parameters
#### **Message**

The Debug message.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Write-ADODebug [-Message] <String> [<CommonParameters>]
```
---
