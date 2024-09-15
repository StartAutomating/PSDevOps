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
> EXAMPLE 1

```PowerShell
Write-ADOWarning "Stuff hit the fan"
```

---

### Parameters
#### **Message**
The Warning message.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|

#### **SourcePath**
An optional source path.

|Type      |Required|Position|PipelineInput        |Aliases                     |
|----------|--------|--------|---------------------|----------------------------|
|`[String]`|false   |2       |true (ByPropertyName)|Source<br/>FullName<br/>File|

#### **LineNumber**
An optional line number.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[UInt32]`|false   |3       |true (ByPropertyName)|Line   |

#### **ColumnNumber**
An optional column number.

|Type      |Required|Position|PipelineInput        |Aliases       |
|----------|--------|--------|---------------------|--------------|
|`[UInt32]`|false   |4       |true (ByPropertyName)|Column<br/>Col|

#### **Code**
An optional Warning code.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Write-ADOWarning [-Message] <String> [[-SourcePath] <String>] [[-LineNumber] <UInt32>] [[-ColumnNumber] <UInt32>] [[-Code] <String>] [<CommonParameters>]
```
