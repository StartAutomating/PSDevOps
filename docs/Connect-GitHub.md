Connect-GitHub
--------------
### Synopsis
Connects to GitHub

---
### Description

Connects to GitHub, automatically creating smart aliases for all GitHub URLs.

---
### Related Links
* [Invoke-GitHubRESTAPI](Invoke-GitHubRESTAPI.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Connect-GitHub
```

---
### Parameters
#### **GitHubOpenAPIUrl**

A URL that contains the GitHub OpenAPI definition



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **PassThru**

If set, will output the dynamically imported module.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Force**

If set, will force a reload of the module.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **PersonalAccessToken**

The personal access token used to connect to GitHub.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Owner**

If provided, will default the [owner] in GitHub API requests



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
#### **UserName**

If provided, will default the [username] in GitHub API requests



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **Repo**

If provided, will default the [repo] in GitHub API requests



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
### Syntax
```PowerShell
Connect-GitHub [[-GitHubOpenAPIUrl] <String>] [-PassThru] [-Force] [[-PersonalAccessToken] <String>] [[-Owner] <String>] [[-UserName] <String>] [[-Repo] <String>] [<CommonParameters>]
```
---
