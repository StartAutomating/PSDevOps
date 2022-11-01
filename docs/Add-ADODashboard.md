Add-ADODashboard
----------------
### Synopsis
Creates Dashboards and Widgets

---
### Description

Creates Dashboards from Azure DevOps, or Creates Widgets in a Dashboard in Azure Devops.

---
### Related Links
* [Get-ADODashboard](Get-ADODashboard.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Add-ADODashboard -Organization MyOrg -Project MyProject -Team MyTeam -Name MyDashboard
```

#### EXAMPLE 2
```PowerShell
Get-ADODashboard -Organization MyOrg -Project MyProject -Team MyTeam |
    Select-Object -First 1 |
    Add-ADODashboard -Name BuildHistory -ContributionID ms.vss-dashboards-web.Microsoft.VisualStudioOnline.Dashboards.BuildHistogramWidget -ColumnSpan 2
```

---
### Parameters
#### **Organization**

The Organization.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Team**

The Team.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Name**

The name of the dashboard or widget.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

A description of the dashboard



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Widget**

Widgets created with the dashboard.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DashboardID**

The DashboardID. This dashboard will contain the new widgets.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ContributionID**

The ContributionID.  This describes the exact extension contribution the widget will use.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Row**

The row of the widget.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Column**

The column of the widget.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **RowSpan**

The number of rows the widget should occupy.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ColumnSpan**

The number of columns the widget should occupy.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Setting**

The widget settings.  Settings are specific to each widget.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



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
* PSDevOps.Dashboard


* PSDevOps.Widget




---
### Syntax
```PowerShell
Add-ADODashboard -Organization <String> -Project <String> [-Team <String>] -Name <String> [-Description <String>] [-Widget <PSObject[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Add-ADODashboard -Organization <String> -Project <String> [-Team <String>] -Name <String> -DashboardID <String> -ContributionID <String> [-Row <Int32>] [-Column <Int32>] [-RowSpan <Int32>] [-ColumnSpan <Int32>] [-Setting <PSObject>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
