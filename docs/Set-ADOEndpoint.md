
Set-ADOEndpoint
---------------
### Synopsis
Sets an ADO Endpoint

---
### Description

Sets a Azure DevOps Endpoint

---
### Related Links
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)
---
### Examples
#### EXAMPLE 1
```PowerShell
Set-ADOEndpoint -ID 000-0000-0000 -Key AccessToken -AccessToken testValue
Set-ADOEndpoint -ID 000-0000-0000 -Key userVariable -Value testValue
Set-ADOEndpoint -ID 000-0000-0000 -Url 'https://example.com/service'
```

---
### Parameters
#### **ID**

The identifier.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Url**

The endpoint URL.



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|true    |named  |true (ByPropertyName)|
---
#### **AccessToken**

The access token



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Name**

The name of the setting.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Value**

The value of the setting.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
### Outputs
System.String


---
### Syntax
```PowerShell
Set-ADOEndpoint -ID <String> -Url <Uri> [<CommonParameters>]
```
```PowerShell
Set-ADOEndpoint -ID <String> -Name <String> -Value <String> [<CommonParameters>]
```
```PowerShell
Set-ADOEndpoint -ID <String> -AccessToken <String> [-Name <String>] [<CommonParameters>]
```
---


