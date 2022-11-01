New-ADOProject
--------------
### Synopsis
Creates new projects in Azure DevOps.

---
### Description

Creates new projects in Azure DevOps or TFS.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/list?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/list?view=azure-devops-rest-5.1)



---
### Examples
#### EXAMPLE 1
```PowerShell
New-ADOProject -Organization StartAutomating -Project Formulaic -PersonalAccessToken $pat
```

---
### Parameters
#### **Name**

The name of the project.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

The project description.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Process**

The process template used by the project.  By default, 'Agile'



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Public**

If set, the project will be created as a public project.
If not set, the project will be created as a private project.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Abbreviation**

The project abbreviation



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: 7

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
* PSDevOps.Project




---
### Syntax
```PowerShell
New-ADOProject [-Name] <String> [-Description] <String> [[-Process] <String>] [-Public] [[-Abbreviation] <String>] [-Organization] <String> [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
