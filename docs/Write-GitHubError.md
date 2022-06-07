
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **File**

An optional source path.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **Line**

An optional line number.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[UInt32]```|false   |3      |true (ByPropertyName)|
---
#### **Col**

An optional column number.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[UInt32]```|false   |4      |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Write-GitHubError [-Message] <String> [[-File] <String>] [[-Line] <UInt32>] [[-Col] <UInt32>] [<CommonParameters>]
```
---


