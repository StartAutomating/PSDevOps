Get-ADODashboard
----------------

### Synopsis
Gets Azure DevOps Dashboards

---

### Description

Gets Azure DevOps Team Dashboards and Widgets within a dashboard.

---

### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/dashboard/dashboards/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/dashboard/dashboards/list)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ADOTeam -Organization MyOrganization -PersonalAccessToken $pat |
    Get-ADODashboard
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
The DashboardID

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Widget**
If set, will widgets within a dashboard.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Widgets|

#### **WidgetID**
The WidgetID.  If provided, will get details about a given Azure DevOps Widget.

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

---

### Outputs
* PSDevOps.Dashboard

* PSDevOps.Widget

---

### Syntax
```PowerShell
Get-ADODashboard -Organization <String> -Project <String> [-Team <String>] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADODashboard -Organization <String> -Project <String> [-Team <String>] -DashboardID <String> -WidgetID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADODashboard -Organization <String> -Project <String> [-Team <String>] -DashboardID <String> -Widget [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADODashboard -Organization <String> -Project <String> [-Team <String>] -DashboardID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
