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



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Url**

The endpoint URL.



> **Type**: ```[Uri]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AccessToken**

The access token



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Name**

The name of the setting.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Value**

The value of the setting.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




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
