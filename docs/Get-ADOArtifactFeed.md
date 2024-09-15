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
> EXAMPLE 1

```PowerShell
Get-ADOArtifactFeed -Organization myOrganization -Project MyProject
```

---

### Parameters
#### **Organization**
The Organization

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|Org    |

#### **Project**
The Project

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **FeedID**
The name or ID of the feed.

|Type      |Required|Position|PipelineInput        |Aliases         |
|----------|--------|--------|---------------------|----------------|
|`[String]`|false   |named   |true (ByPropertyName)|fullyQualifiedId|

#### **View**
If set, will Get Artifact Feed Views

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Views  |

#### **Permission**
If set, will get artifact permissions

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Permissions|

#### **RetentionPolicy**
If set, will get artifact retention policies

|Type      |Required|Position|PipelineInput        |Aliases          |
|----------|--------|--------|---------------------|-----------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|RetentionPolicies|

#### **PackageVersionList**
If set, will list versions of a particular package.

|Type      |Required|Position|PipelineInput        |Aliases                                         |
|----------|--------|--------|---------------------|------------------------------------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|ListVersions<br/>ListVersion<br/>PackageVersions|

#### **Provenance**
If set, will get provenance for a package version

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|

#### **VersionID**
A package version ID.  Only required when getting version provenance.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **PackageList**
If set, will list packages within a feed.

|Type      |Required|Position|PipelineInput        |Aliases                                  |
|----------|--------|--------|---------------------|-----------------------------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|ListPackages<br/>ListPackage<br/>Packages|

#### **IncludeAllVersion**
If set, will include all versions of packages within a feed.

|Type      |Required|Position|PipelineInput        |Aliases           |
|----------|--------|--------|---------------------|------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|IncludeAllVersions|

#### **IncludeDescription**
If set, will include descriptions of a package.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **ProtocolType**
If provided, will return packages of a given protocol.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **NPM**
If set, will get information about a Node Package Manager module.

|Type      |Required|Position|PipelineInput        |Aliases           |
|----------|--------|--------|---------------------|------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|NodePackageManager|

#### **NuGet**
If set, will get information about a Nuget module.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|

#### **Python**
If set, will get information about a Python module.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|PyPi   |

#### **Universal**
If set, will get information about a Universal package module.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|UPack  |

#### **PackageName**
The Package Name.  Must be used with -NPM, -NuGet, -Python, or -Universal.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **PackageVersion**
The Package Version.  Must be used with -NPM, -NuGet, -Python, or -Universal.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **FeedRole**
The Feed Role
Valid Values:

* Administrator
* Collaborator
* Contributor
* Reader

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **PackageID**
A -PackageID.  This can be used to get Packages -Metrics, -ListPackageVersion, or get -Provenance of a particular version.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Metric**
If set, will get package metrics.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|true    |named   |false        |Metrics|

#### **IncludeDeleted**
If set, will include deleted feeds.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Change**
If set, will get changes in artifact feeds.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Changes|

#### **Server**
The server.  By default https://feeds.dev.azure.com/.

|Type   |Required|Position|PipelineInput|
|-------|--------|--------|-------------|
|`[Uri]`|false   |named   |false        |

#### **ApiVersion**
The api version.  By default, 5.1-preview.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

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
