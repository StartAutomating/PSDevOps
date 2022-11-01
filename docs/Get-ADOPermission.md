Get-ADOPermission
-----------------
### Synopsis
Gets Azure DevOps Permissions

---
### Description

Gets Azure DevOps security permissions.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20lists/query](https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20lists/query)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/security/security%20namespaces/query](https://docs.microsoft.com/en-us/rest/api/azure/devops/security/security%20namespaces/query)



* [https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference](https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOPermission -Organization MyOrganization -Project MyProject -PersonalAccessToken $pat
```

#### EXAMPLE 2
```PowerShell
Get-ADOProject -Organization MyOrganization -Project MyProject | # Get the project
    Get-ADOTeam | # get the teams within the project
    Get-ADOPermission -Dashboard # get the dashboard permissions of each team within the project.
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
#### **PermissionType**

If set, will list the type of permisssions.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NamespaceID**

The Security Namespace ID.
For details about each namespace, see:
https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SecurityToken**

The Security Token.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProjectID**

The Project ID.
If this is provided without anything else, will get permissions for the projectID



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TeamID**

If provided, will get permissions related to a given teamID. ( see Get-ADOTeam)



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AreaPath**

If provided, will get permissions related to an Area Path. ( see Get-ADOAreaPath )



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IterationPath**

If provided, will get permissions related to an Iteration Path. ( see Get-ADOIterationPath )



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Overview**

If set, will get common permissions related to a project.
These are:
* Builds
* Boards
* Dashboards
* Git Repositories
* ServiceEndpoints
* Project Permissions
* Service Endpoints
* ServiceHooks



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Tagging**

If set, will get permissions for tagging related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Analytics**

If set, will get permissions for analytics related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ManageTFVC**

If set, will get permissions for Team Foundation Version Control related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Plan**

If set, will get permissions for Delivery Plans.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Dashboard**

If set, will get dashboard permissions related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ServiceEndpoint**

If set, will get all service endpoints permissions.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **EndpointID**

If set, will get endpoint permissions related to a particular endpoint.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DefinitionID**

The Build Definition ID



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildPath**

The path to the build.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildPermission**

If set, will get build and release permissions for a given project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **RepositoryID**

If provided, will get build and release permissions for a given project's repositoryID



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **BranchName**

If provided, will get permissions for a given branch within a repository



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProjectRepository**

If set, will get permissions for repositories within a project



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AllRepository**

If set, will get permissions for repositories within a project



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Descriptor**

The Descriptor



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Recurse**

If set and this is a hierarchical namespace, return child ACLs of the specified token.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeExtendedInfo**

If set, populate the extended information properties for the access control entries in the returned lists.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ExpandACL**

If set, will expand the ACE dictionary returned



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



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
* PSDevOps.SecurityNamespace


* PSDevOps.AccessControlList




---
### Syntax
```PowerShell
Get-ADOPermission -Organization <String> [-PermissionType] [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -NamespaceID <String> [-SecurityToken <String>] [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -Overview [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -ProjectRepository [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -RepositoryID <String> [-BranchName <String>] [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -IterationPath <String> [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -BuildPermission [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -DefinitionID <String> [-BuildPath <String>] [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -ManageTFVC [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -Tagging [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> [-TeamID <String>] -Dashboard [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> -AreaPath <String> [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> [-ProjectID <String>] -EndpointID <String> [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> [-ProjectID <String>] -Analytics [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ProjectID <String> [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -Plan [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> -ServiceEndpoint [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPermission -Organization <String> [-BranchName <String>] -AllRepository [-Descriptor <String[]>] [-Recurse] [-IncludeExtendedInfo] [-ExpandACL] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
