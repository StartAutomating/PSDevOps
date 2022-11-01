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
#### EXAMPLE 1
```PowerShell
Add-ADOAttachment -Path .\a.zip
```

#### EXAMPLE 2
```PowerShell
Add-ADOAttachment -Path .\summary.md -IsSummary
```

#### EXAMPLE 3
```PowerShell
Add-ADOAttachment -Path .\log.txt -IsLog
```

---
### Parameters
#### **Path**

The attachment path.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Name**

The Attachment name.  This is used to upload information for an Azure DevOps extension.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Type**

The Attachment type.  This is used to upload information for an Azure DevOps extension.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **ContainerFolder**

The Container Folder.  This is required when uploading artifacts.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ArtifactName**

The Artifact Name.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IsSummary**

If set, the upload will be treated as a summary.  Summary uploads must be markdown.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IsLog**

If set, the upload will be treated as a log file.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



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
---
