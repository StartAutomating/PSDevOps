Add-ADOAttachment
-----------------

### Synopsis
Adds an ADO Attachment

---

### Description

Adds an Azure DevOps Attachment

---

### Related Links
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)

---

### Examples
> EXAMPLE 1

```PowerShell
Add-ADOAttachment -Path .\a.zip
```
> EXAMPLE 2

```PowerShell
Add-ADOAttachment -Path .\summary.md -IsSummary
```
> EXAMPLE 3

```PowerShell
Add-ADOAttachment -Path .\log.txt -IsLog
```

---

### Parameters
#### **Path**
The attachment path.

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|true    |named   |true (ByPropertyName)|Fullname|

#### **Name**
The Attachment name.  This is used to upload information for an Azure DevOps extension.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|

#### **Type**
The Attachment type.  This is used to upload information for an Azure DevOps extension.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |2       |true (ByPropertyName)|

#### **ContainerFolder**
The Container Folder.  This is required when uploading artifacts.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **ArtifactName**
The Artifact Name.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **IsSummary**
If set, the upload will be treated as a summary.  Summary uploads must be markdown.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Summary|

#### **IsLog**
If set, the upload will be treated as a log file.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Log    |

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Add-ADOAttachment -Path <String> [<CommonParameters>]
```
```PowerShell
Add-ADOAttachment -Path <String> -ContainerFolder <String> -ArtifactName <String> [<CommonParameters>]
```
```PowerShell
Add-ADOAttachment -Path <String> -IsLog [<CommonParameters>]
```
```PowerShell
Add-ADOAttachment -Path <String> -IsSummary [<CommonParameters>]
```
```PowerShell
Add-ADOAttachment -Path <String> [-Name] <String> [-Type] <String> [<CommonParameters>]
```
