Remove-ADOWiki
--------------

### Synopsis
Removes Azure DevOps Wikis

---

### Description

Removes Azure DevOps Wikis from a project.

---

### Related Links
* [Add-ADOWiki](Add-ADOWiki.md)

* [Get-ADOWiki](Get-ADOWiki.md)

* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/delete](https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/delete)

---

### Examples
> EXAMPLE 1

```PowerShell
Remove-ADOWiki -Organization MyOrg -Project MyProject
```

---

### Parameters
#### **Organization**
The Organization.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |1       |true (ByPropertyName)|Org    |

#### **Project**
The Project.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |2       |true (ByPropertyName)|

#### **WikiID**
The WikiID.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |3       |true (ByPropertyName)|

#### **RepositoryID**
The RepositoryID.  If this is the same as the WikiID, it is a ProjectWiki, and the repository will be removed.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **Server**
The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |5       |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |6       |false        |

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

* [Collections.Hashtable](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.Hashtable)

---

### Syntax
```PowerShell
Remove-ADOWiki [-Organization] <String> [-Project] <String> [-WikiID] <String> [[-RepositoryID] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
