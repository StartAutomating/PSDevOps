
Write-GitHubDebug
-----------------
### Synopsis
Writes a Git Warning

---
### Description

Writes an GitHub Workflow Warning

---
### Related Links
* [Write-GitHubError](Write-GitHubError.md)
* [https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions](https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions)
---
### Examples
#### EXAMPLE 1
```PowerShell
Write-GitHubDebug "Debugging"
```

---
### Parameters
#### **Message**

The Debug message.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Write-GitHubDebug [-Message] <String> [<CommonParameters>]
```
---


