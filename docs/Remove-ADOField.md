Remove-ADOField
---------------

### Synopsis
Removes fields in Azure DevOps

---

### Description

Removes fields in Azure DevOps or Team Foundation Server.

---

### Related Links
* [Get-ADOField](Get-ADOField.md)

* [New-ADOField](New-ADOField.md)

* [Invoke-ADORestAPI](Invoke-ADORestAPI.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Remove-ADOField -Name Cmdlet.Verb
```
> EXAMPLE 2

```PowerShell
Remove-ADOField -Name IsDCR
```

---

### Parameters
#### **Name**
The name or reference name of the field

|Type      |Required|Position|PipelineInput        |Aliases                                                      |
|----------|--------|--------|---------------------|-------------------------------------------------------------|
|`[String]`|true    |1       |true (ByPropertyName)|FriendlyName<br/>DisplayName<br/>ReferenceName<br/>SystemName|

#### **Organization**
The Organization

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |2       |true (ByPropertyName)|Org    |

#### **Project**
The Project

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **Server**
The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |4       |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |5       |false        |

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
Remove-ADOField [-Name] <String> [-Organization] <String> [[-Project] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
