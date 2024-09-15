Remove-ADOArtifactFeed
----------------------

### Synopsis
Removes artifact feeds from Azure DevOps

---

### Description

Removes artifact feeds from Azure DevOps.  Artifact feeds are used to publish packages.

---

### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ADOArtifactFeed -Organization MyOrg -Project MyProject -FeedId MyFeed |
    Remove-ADOArtifactFeed
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
The Feed Name or ID
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd

|Type      |Required|Position|PipelineInput        |Aliases         |
|----------|--------|--------|---------------------|----------------|
|`[String]`|true    |named   |true (ByPropertyName)|FullyQualifiedID|

#### **ViewID**
The View Name or ID
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **View**
If set, will remove a view.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|

#### **Server**
The server.  By default https://feeds.dev.azure.com/.

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1-preview.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

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
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)

* [Collections.IDictionary](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.IDictionary)

---

### Syntax
```PowerShell
Remove-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-ViewID <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-ViewID <String>] -View [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
