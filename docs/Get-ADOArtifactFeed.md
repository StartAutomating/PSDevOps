
Get-ADOArtifactFeed
-------------------
### Synopsis
Gets artifact feeds from Azure DevOps

---
### Description

Gets artifact feeds from Azure DevOps.  Artifact feeds can be used to publish packages.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/get%20feeds?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/get%20feeds?view=azure-devops-rest-5.1)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOArtifactFeed -Organization myOrganization -Project MyProject
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Project**

The Project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **FeedID**

The name or ID of the feed.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **View**

If set, will Get Artifact Feed Views



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Permission**

If set, will get artifact permissions



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **RetentionPolicy**

If set, will get artifact retention policies



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **PackageVersionList**

If set, will list versions of a particular package.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Provenance**

If set, will get provenance for a package version



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **VersionID**

A package version ID.  Only required when getting version provenance.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **PackageList**

If set, will list packages within a feed.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **IncludeAllVersion**

If set, will include all versions of packages within a feed.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **IncludeDescription**

If set, will include descriptions of a package.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **ProtocolType**

If provided, will return packages of a given protocol.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **NPM**

If set, will get information about a Node Package Manager module.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **NuGet**

If set, will get information about a Nuget module.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Python**

If set, will get information about a Python module.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Universal**

If set, will get information about a Universal package module.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **PackageName**

The Package Name.  Must be used with -NPM, -NuGet, -Python, or -Universal.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **PackageVersion**

The Package Version.  Must be used with -NPM, -NuGet, -Python, or -Universal.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **FeedRole**

The Feed Role



Valid Values:

* Administrator
* Collaborator
* Contributor
* Reader
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **PackageID**

A -PackageID.  This can be used to get Packages -Metrics, -ListPackageVersion, or get -Provenance of a particular version.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Metric**

If set, will get package metrics.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **IncludeDeleted**

If set, will include deleted feeds.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Change**

If set, will get changes in artifact feeds.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Server**

The server.  By default https://feeds.dev.azure.com/.



|Type       |Requried|Postion|PipelineInput|
|-----------|--------|-------|-------------|
|```[Uri]```|false   |named  |false        |
---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
### Outputs
PSDevOps.ArtfiactFeed


PSDevOps.ArtfiactFeed.View


PSDevOps.ArtfiactFeed.Change


---
### Syntax
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -View [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -Permission [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -RetentionPolicy [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -PackageVersionList [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -Provenance -VersionID <String> [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -PackageList [-IncludeAllVersion] [-IncludeDescription] [-ProtocolType <String>] [-PackageName <String>] [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -NPM -PackageName <String> -PackageVersion <String> [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -NuGet -PackageName <String> -PackageVersion <String> [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -Python -PackageName <String> -PackageVersion <String> [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -Universal -PackageName <String> -PackageVersion <String> [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] [-FeedRole <String>] [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOArtifactFeed -Organization <String> [-Project <String>] [-FeedID <String>] -PackageID <String> -Metric [-IncludeDeleted] [-Change] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---


