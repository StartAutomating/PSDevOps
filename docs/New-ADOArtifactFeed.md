New-ADOArtifactFeed
-------------------
### Synopsis
Creates artifact feeds and views in Azure DevOps

---
### Description

Creates artifact feeds and feed views in Azure DevOps.

Artifact feeds are used to publish packages.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed%20view?view=azure-devops-rest-5.1#feedvisibility](https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed%20view?view=azure-devops-rest-5.1#feedvisibility)



---
### Examples
#### EXAMPLE 1
```PowerShell
New-ADOArtifactFeed -Organization MyOrg -Project MyProject -Name Builds -Description "Builds of MyProject"
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
#### **Name**

The Feed Name
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

The feed description.
?<> -CharacterClass Any -Min 1 -Max 255 -StartAnchor StringStart -EndAnchor StringEnd



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoBadge**

If set, this feed will not support the generation of package badges.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



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



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **UpstreamSource**

A property bag describing upstream sources



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AllowConflictUpstream**

If set, will allow package names to conflict with the names of packages upstream.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IsReadOnly**

If set, all packages in the feed are immutable.
It is important to note that feed views are immutable; therefore, this flag will always be set for views.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FeedID**

The feed id.  This can be supplied to create a veiw for a particular feed.



> **Type**: ```[Guid]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ShowDeletedPackageVersions**

If set, the feed will not hide all deleted/unpublished versions



> **Type**: ```[Switch]```

> **Required**: false

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
#### **View**

If set, will create a new view for an artifact feed.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ViewVisibility**

The visibility of the view.  By default, the view will be visible to the entire organization.



Valid Values:

* Collection
* Organization
* Private



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://feeds.dev.azure.com/.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



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
* PSDevOps.ArtifactFeed


* PSDevOps.ArtifactFeed.View




---
### Syntax
```PowerShell
New-ADOArtifactFeed -Organization <String> [-Project <String>] -Name <String> [-Description <String>] [-NoBadge] [-PublicUpstream <String[]>] [-UpstreamSource <PSObject[]>] [-AllowConflictUpstream] [-IsReadOnly] [-FeedID <Guid>] [-ShowDeletedPackageVersions] [-FeedRole <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
New-ADOArtifactFeed -Organization <String> [-Project <String>] -Name <String> -FeedID <Guid> -View [-ViewVisibility <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
