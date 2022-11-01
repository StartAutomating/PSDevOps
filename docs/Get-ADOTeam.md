Get-ADOTeam
-----------
### Synopsis
Gets Azure DevOps Teams

---
### Description

Gets teams from Azure DevOps or TFS

---
### Related Links
* [Get-ADOProject](Get-ADOProject.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOTeam -Organization StartAutomating
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

The project name or identifier



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Mine**

If set, will return teams in which the current user is a member.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TeamID**

The Team Identifier



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Member**

If set, will return members of a team.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **SecurityDescriptor**

The Security Descriptor.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Identity**

If set, will return the team identity.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Setting**

If set, will return the team settings.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **FieldValue**

If set, will return the team field values.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Iteration**

If set, will return iterations for the team.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Board**

If set, will list team workboards.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **SecurityGroup**

If set, will list the security groups.



> **Type**: ```[Switch]```

> **Required**: true

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
* PSDevOps.Team


* PSDevOps.TeamMember




---
### Syntax
```PowerShell
Get-ADOTeam -Organization <String> [-Mine] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> [-Project <String>] [-TeamID <String>] -Identity [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> -TeamID <String> -Board [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> -TeamID <String> -Iteration [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> -TeamID <String> -FieldValue [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> -TeamID <String> -Setting [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> -TeamID <String> -Member [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> -TeamID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Project <String> [-Mine] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -Member -SecurityDescriptor <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTeam -Organization <String> -SecurityGroup [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
