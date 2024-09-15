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
> EXAMPLE 1

```PowerShell
Set-ADOEndpoint -ID 000-0000-0000 -Key AccessToken -AccessToken testValue
Set-ADOEndpoint -ID 000-0000-0000 -Key userVariable -Value testValue
Set-ADOEndpoint -ID 000-0000-0000 -Url 'https://example.com/service'
```

---

### Parameters
#### **ID**
The identifier.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Url**
The endpoint URL.

|Type   |Required|Position|PipelineInput        |Aliases            |
|-------|--------|--------|---------------------|-------------------|
|`[Uri]`|true    |named   |true (ByPropertyName)|URI<br/>EndpointURL|

#### **AccessToken**
The access token

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|AT     |

#### **Name**
The name of the setting.

|Type      |Required|Position|PipelineInput        |Aliases        |
|----------|--------|--------|---------------------|---------------|
|`[String]`|true    |named   |true (ByPropertyName)|Key<br/>K<br/>N|

#### **Value**
The value of the setting.

|Type      |Required|Position|PipelineInput        |Aliases                   |
|----------|--------|--------|---------------------|--------------------------|
|`[String]`|true    |named   |true (ByPropertyName)|DataParameter<br/>DP<br/>V|

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
