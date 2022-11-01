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



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FeedID**

The name or ID of the feed.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **View**

If set, will Get Artifact Feed Views



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Permission**

If set, will get artifact permissions



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **RetentionPolicy**

If set, will get artifact retention policies



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PackageVersionList**

If set, will list versions of a particular package.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Provenance**

If set, will get provenance for a package version



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **VersionID**

A package version ID.  Only required when getting version provenance.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PackageList**

If set, will list packages within a feed.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeAllVersion**

If set, will include all versions of packages within a feed.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeDescription**

If set, will include descriptions of a package.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProtocolType**

If provided, will return packages of a given protocol.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NPM**

If set, will get information about a Node Package Manager module.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NuGet**

If set, will get information about a Nuget module.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Python**

If set, will get information about a Python module.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Universal**

If set, will get information about a Universal package module.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PackageName**

The Package Name.  Must be used with -NPM, -NuGet, -Python, or -Universal.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PackageVersion**

The Package Version.  Must be used with -NPM, -NuGet, -Python, or -Universal.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FeedRole**

The Feed Role



Valid Values:

* Administrator
* Collaborator
* Contributor
* Reader



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PackageID**

A -PackageID.  This can be used to get Packages -Metrics, -ListPackageVersion, or get -Provenance of a particular version.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Metric**

If set, will get package metrics.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **IncludeDeleted**

If set, will include deleted feeds.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Change**

If set, will get changes in artifact feeds.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Server**

The server.  By default https://feeds.dev.azure.com/.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* PSDevOps.ArtfiactFeed


* PSDevOps.ArtfiactFeed.View


* PSDevOps.ArtfiactFeed.Change




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
