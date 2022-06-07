
Set-ADOPermission
-----------------
### Synopsis
Sets Azure DevOps Permissions

---
### Description

Sets Azure DevOps security permissions.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20entries/set%20access%20control%20entries](https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20entries/set%20access%20control%20entries)
* [https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference](https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference)
---
### Examples
#### EXAMPLE 1
```PowerShell
Set-ADOPermission -Organization MyOrganization -Project MyProject -PersonalAccessToken $pat
```

---
### Parameters
#### **Organization**

The Organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ProjectID**

The Project ID.
If this is provided without anything else, will get permissions for the projectID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **TeamID**

If provided, will set permissions related to a given teamID. ( see Get-ADOTeam)



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **AreaPath**

If provided, will set permissions related to an Area Path. ( see Get-ADOAreaPath )



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **IterationPath**

If provided, will set permissions related to an Iteration Path. ( see Get-ADOIterationPath )



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **DefinitionID**

The Build Definition ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **BuildPath**

The path to the build.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **BuildPermission**

If set, will set build and release permissions for a given project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **ProjectRepository**

If set, will set permissions for repositories within a project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **RepositoryID**

If provided, will set permissions for a given repositoryID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **BranchName**

If provided, will set permissions for a given branch within a repository



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **AllRepository**

If set, will set permissions for all repositories within a project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Tagging**

If set, will set permissions for tagging related to the current project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **ManageTFVC**

If set, will set permissions for Team Foundation Version Control related to the current project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Plan**

If set, will set permissions for Delivery Plans.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Dashboard**

If set, will set dashboard permissions related to the current project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **EndpointID**

If set, will set endpoint permissions related to a particular endpoint.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **PermissionType**

If set, will list the type of permisssions.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **NamespaceID**

The Security Namespace ID.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **SecurityToken**

The Security Token.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Descriptor**

One or more descriptors



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **Identity**

One or more identities.  Identities will be converted into descriptors.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **Allow**

One or more allow permissions.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **Deny**

One or more deny permissions.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **Overwrite**

If set, will overwrite this entry with existing entries.
By default, will merge permissions for the specified token.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Inherit**

If set, will inherit this permissions.
By permissions will not be inherited.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |named  |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
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
PSDevOps.SecurityNamespace


PSDevOps.AccessControlList


---
### Syntax
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -ProjectRepository [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -RepositoryID <String> [-BranchName <String>] [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -BuildPermission [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -DefinitionID <String> [-BuildPath <String>] [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -ManageTFVC [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -Tagging [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -IterationPath <String> [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> [-TeamID <String>] -Dashboard [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> -AreaPath <String> [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> [-ProjectID <String>] -EndpointID <String> [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> [-ProjectID <String>] [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -ProjectID <String> [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> [-BranchName <String>] -AllRepository [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -Plan [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> [-PermissionType] [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Set-ADOPermission -Organization <String> -NamespaceID <String> -SecurityToken <String> [-Descriptor <String[]>] [-Identity <String[]>] [-Allow <String[]>] [-Deny <String[]>] [-Overwrite] [-Inherit] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


