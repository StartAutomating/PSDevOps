Write-GitHubWarning
-------------------

### Synopsis
Writes an Git Warning

---

### Description

Writes an GitHub Workflow Warning

---

### Related Links
* [Write-GitHubError](Write-GitHubError.md)

* [https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions](https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions)

---

### Examples
> EXAMPLE 1

```PowerShell
Write-GitHubWarning "Stuff hit the fan"
```

---

### Parameters
#### **Message**
The Warning message.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|

#### **File**
An optional source path.

|Type      |Required|Position|PipelineInput        |Aliases                           |
|----------|--------|--------|---------------------|----------------------------------|
|`[String]`|false   |2       |true (ByPropertyName)|Source<br/>SourcePath<br/>FullName|

#### **Line**
An optional line number.

|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[UInt32]`|false   |3       |true (ByPropertyName)|LineNumber|

#### **Col**
An optional column number.

|Type      |Required|Position|PipelineInput        |Aliases                |
|----------|--------|--------|---------------------|-----------------------|
|`[UInt32]`|false   |4       |true (ByPropertyName)|Column<br/>ColumnNumber|

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Write-GitHubWarning [-Message] <String> [[-File] <String>] [[-Line] <UInt32>] [[-Col] <UInt32>] [<CommonParameters>]
```
