Remove-ADODashboard
-------------------

### Synopsis
Removes Dashboards and Widgets

---

### Description

Removes Dashboards from Azure DevOps, or Removes Widgets from a Dashboard in Azure Devops.

---

### Related Links
* [Get-ADODashboard](Get-ADODashboard.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ADODashboard -Organization MyOrg -Project MyProject -Team MyTeam | Remove-ADODashboard
```
> EXAMPLE 2

```PowerShell
Get-ADODashboard -Organization MyOrg -Project MyProject -Team MyTeam -Widget | Remove-ADODashboard
```

---

### Parameters
#### **Organization**
The Organization.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|Org    |

#### **Project**
The Project.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Team**
The Team.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **DashboardID**
The DashboardID.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **WidgetID**
The WidgetID.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Server**
The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops

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

* [Collections.Hashtable](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.Hashtable)

---

### Syntax
```PowerShell
Remove-ADODashboard -Organization <String> -Project <String> [-Team <String>] -DashboardID <String> -WidgetID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADODashboard -Organization <String> -Project <String> [-Team <String>] -DashboardID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
