
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |1      |true (ByPropertyName)|
---
#### **PassThru**

If set, will output the dynamically imported module.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Force**

If set, will force a reload of the module.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **PersonalAccessToken**

The personal access token used to connect to GitHub.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **Owner**

If provided, will default the [owner] in GitHub API requests



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |3      |false        |
---
#### **UserName**

If provided, will default the [username] in GitHub API requests



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |4      |false        |
---
#### **Repo**

If provided, will default the [repo] in GitHub API requests



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |5      |false        |
---
### Syntax
```PowerShell
Connect-GitHub [[-GitHubOpenAPIUrl] <String>] [-PassThru] [-Force] [[-PersonalAccessToken] <String>] [[-Owner] <String>] [[-UserName] <String>] [[-Repo] <String>] [<CommonParameters>]
```
---


