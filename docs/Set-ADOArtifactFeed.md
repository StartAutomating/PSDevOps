
Set-ADOArtifactFeed
-------------------
### Synopsis
Set Azure DevOps Artifact Feed

---
### Description

Changes the settings, permissions, views, and retention policies of an Azure DevOps Artifact Feed.

---
### Related Links
* [Get-ADOArtifactFeed](Get-ADOArtifactFeed.md)
* [New-ADOArtifactFeed](New-ADOArtifactFeed.md)
* [Remove-ADOArtifactFeed](Remove-ADOArtifactFeed.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Set-ADOArtifactFeed -Organization StartAutomating -Project PSDevOps -FeedId 'Builds' -Description 'Project Builds' -WhatIf
```

#### EXAMPLE 2
```PowerShell
Set-ADOArtifactFeed -RetentionPolicy -Organization StartAutomating -Project PSDevOps -FeedId 'Builds' -WhatIf -DaysToKeep 10
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
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Name**

The Feed Name or View Name
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **ShowDeletedPackageVersions**

If set, the feed will not hide all deleted/unpublished versions



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **AllowConflictUpstream**

If set, will allow package names to conflict with the names of packages upstream.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **NoBadge**

If set, this feed will not support the generation of package badges.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **PublicUpstream**

If provided, will allow upstream sources from public repositories.
Upstream sources allow your packages to depend on packages in public repositories or private feeds.



Valid Values:

* NPM
* NuGet
* PyPi
* Maven
* PowerShellGallery
|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **UpstreamSource**

A property bag describing upstream sources



|Type              |Requried|Postion|PipelineInput        |
|------------------|--------|-------|---------------------|
|```[PSObject[]]```|false   |named  |true (ByPropertyName)|
---
#### **Description**

The feed description.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **ViewID**

The ViewID.
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ViewVisibility**

The view visibility.  By default, views are visible to all members of an organization.



Valid Values:

* Collection
* Organization
* Private
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Permission**

If set, will set artifact permissions.



|Type              |Requried|Postion|PipelineInput        |
|------------------|--------|-------|---------------------|
|```[PSObject[]]```|true    |named  |true (ByPropertyName)|
---
#### **RetentionPolicy**

If set, will set artifact retention policies



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **CountLimit**

Maximum versions to preserve per package and package type.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[UInt32]```|false   |named  |true (ByPropertyName)|
---
#### **DaysToKeep**

Number of days to preserve a package version after its latest download.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[UInt32]```|false   |named  |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://feeds.dev.azure.com/.



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |named  |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Outputs
PSDevOps.ArtifactFeed


PSDevOps.ArtfiactFeed.RetentionPolicy


PSDevOps.ArtfiactFeed.View


---
### Syntax
```PowerShell
Set-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-Name <String>] -ViewID <String> [-ViewVisibility <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-Name <String>] [-ShowDeletedPackageVersions] [-AllowConflictUpstream] [-NoBadge] [-PublicUpstream <String[]>] [-UpstreamSource <PSObject[]>] [-Description <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> -Permission <PSObject[]> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> -RetentionPolicy [-CountLimit <UInt32>] [-DaysToKeep <UInt32>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


