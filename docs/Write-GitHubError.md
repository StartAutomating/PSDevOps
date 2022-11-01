Write-GitHubError
-----------------
### Synopsis
Writes a Git Error

---
### Description

Writes a GitHub Workflow Error

---
### Related Links
* [Write-GitHubWarning](Write-GitHubWarning.md)



* [https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions](https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions)



---
### Examples
#### EXAMPLE 1
```PowerShell
Write-GitHubError "Stuff hit the fan"
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
#### **File**

An optional source path.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Line**

An optional line number.



> **Type**: ```[UInt32]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Col**

An optional column number.



> **Type**: ```[UInt32]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Write-GitHubError [-Message] <String> [[-File] <String>] [[-Line] <UInt32>] [[-Col] <UInt32>] [<CommonParameters>]
```
---
