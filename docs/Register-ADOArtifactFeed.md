Register-ADOArtifactFeed
------------------------

### Synopsis
Registers an Azure DevOps artifact feed.

---

### Description

Registers an Azure DevOps artifact feed as a PowerShell Repository.
thThis allows Install-Module, Publish-Module, and Save-Module to work against an Azure DevOps artifact feed.

---

### Related Links
* [https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops](https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops)

* [Get-ADOArtifactFeed](Get-ADOArtifactFeed.md)

* [Unregister-ADOArtifactFeed](Unregister-ADOArtifactFeed.md)

* [Get-PSRepository](Get-PSRepository.md)

* [Register-PSRepository](Register-PSRepository.md)

* [Unregister-PSRepository](Unregister-PSRepository.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Register-ADOArtifactFeed -Organization MyOrg -Project MyProject -Name MyFeed -PersonalAccessToken $myPat
```

---

### Parameters
#### **Organization**
The name of the organization.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|

#### **Project**
The Project

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Name**
The name or ID of the feed.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |3       |true (ByPropertyName)|

#### **PersonalAccessToken**
The personal access token used to connect to the feed.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |4       |true (ByPropertyName)|PAT    |

#### **EmailAddress**
The email address used to connect

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|

#### **RepositoryName**
If provided, will create a repository source using a given name.
By default, the RepositoryName will be $Organization-$Project-$Name

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|

#### **RepositoryUrl**
If provided, will create a repository using a given URL.
By default, the RepositoryURL is predicted using -Organization, -Project, and -Name

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|

#### **Force**
If set, will remove the connection to an existing feed and then create a new one.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Outputs
* Microsoft.PowerShell.Commands.PSRepository

---

### Syntax
```PowerShell
Register-ADOArtifactFeed [-Organization] <String> [[-Project] <String>] [-Name] <String> [[-PersonalAccessToken] <String>] [[-EmailAddress] <String>] [[-RepositoryName] <String>] [[-RepositoryUrl] <String>] [-Force] [<CommonParameters>]
```
