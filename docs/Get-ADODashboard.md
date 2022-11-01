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
#### EXAMPLE 1
```PowerShell
Get-ADOTeam -Organization MyOrganization -PersonalAccessToken $pat |
    Get-ADODashboard
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
#### **DashboardID**

The DashboardID



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Widget**

If set, will widgets within a dashboard.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **WidgetID**

The WidgetID.  If provided, will get details about a given Azure DevOps Widget.



> **Type**: ```[String]```

> **Required**: true

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
---
