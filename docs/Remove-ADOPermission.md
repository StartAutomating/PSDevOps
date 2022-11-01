Remove-ADOPermission
--------------------
### Synopsis
Removes Azure DevOps Permissions

---
### Description

Removes Azure DevOps security permissions.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20entries/set%20access%20control%20entries](https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20entries/set%20access%20control%20entries)



* [https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference](https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference)



---
### Examples
#### EXAMPLE 1
```PowerShell
Remove-ADOPermission -Organization MyOrganization -Project MyProject -PersonalAccessToken $pat
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
#### **ProjectID**

The Project ID.
If this is provided without anything else, will get permissions for the projectID



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TeamID**

If provided, will set permissions related to a given teamID. ( see Get-ADOTeam)



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AreaPath**

If provided, will set permissions related to an Area Path. ( see Get-ADOAreaPath )



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IterationPath**

If provided, will set permissions related to an Iteration Path. ( see Get-ADOIterationPath )



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

If set, will set build and release permissions for a given project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProjectRepository**

If set, will set permissions for repositories within a project



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **RepositoryID**

If provided, will set permissions for a given repositoryID



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **BranchName**

If provided, will set permissions for a given branch within a repository



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AllRepository**

If set, will set permissions for all repositories within a project



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Tagging**

If set, will set permissions for tagging related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ManageTFVC**

If set, will set permissions for Team Foundation Version Control related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Plan**

If set, will set permissions for Delivery Plans.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Dashboard**

If set, will set dashboard permissions related to the current project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **EndpointID**

If set, will set endpoint permissions related to a particular endpoint.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NamespaceID**

The Security Namespace ID.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SecurityToken**

The Security Token.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Descriptor**

One or more descriptors



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Identity**

One or more identities.  Identities will be converted into descriptors.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Permission**

One or more allow permissions.



> **Type**: ```[String[]]```

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
* PSDevOps.SecurityNamespace


* PSDevOps.AccessControlList




---
### Syntax
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -ProjectRepository [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -RepositoryID <String> [-BranchName <String>] [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -BuildPermission [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -DefinitionID <String> [-BuildPath <String>] [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -ManageTFVC [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -Tagging [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -IterationPath <String> [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> [-TeamID <String>] -Dashboard [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> -AreaPath <String> [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> [-ProjectID <String>] -EndpointID <String> [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> [-ProjectID <String>] [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -ProjectID <String> [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> [-BranchName <String>] -AllRepository [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -Plan [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOPermission -Organization <String> -NamespaceID <String> -SecurityToken <String> [-Descriptor <String[]>] [-Identity <String[]>] [-Permission <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
