
Hide-GitHubOutput
-----------------
### Synopsis
Masks output

---
### Description

Prevents a message from being printed in a GitHub Workflow log.

---
### Related Links
* [Write-GitHubOutput](Write-GitHubOutput.md)
* [https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions](https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions)
---
### Examples
#### EXAMPLE 1
```PowerShell
Hide-GitHubOutput 'IsItSecret?'
'IsItSecret?' | Out-Host
```

---
### Parameters
#### **Message**

The message to hide.  Any time this string would appear in logs, it will be replaced by asteriks.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Hide-GitHubOutput [-Message] <String> [<CommonParameters>]
```
---


