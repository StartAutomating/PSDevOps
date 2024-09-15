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
> EXAMPLE 1

```PowerShell
Get-ADOTeam -Organization StartAutomating
```

---

### Parameters
#### **Organization**
The Organization.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|Org    |

#### **Project**
The project name or identifier

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Mine**
If set, will return teams in which the current user is a member.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|false   |named   |true (ByPropertyName)|My     |

#### **TeamID**
The Team Identifier

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Member**
If set, will return members of a team.

|Type      |Required|Position|PipelineInput|Aliases               |
|----------|--------|--------|-------------|----------------------|
|`[Switch]`|true    |named   |false        |Members<br/>Membership|

#### **SecurityDescriptor**
The Security Descriptor.

|Type      |Required|Position|PipelineInput        |Aliases                                                       |
|----------|--------|--------|---------------------|--------------------------------------------------------------|
|`[String]`|true    |named   |true (ByPropertyName)|SD<br/>UserDescriptor<br/>TeamDescriptor<br/>SubjectDescriptor|

#### **Identity**
If set, will return the team identity.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **Setting**
If set, will return the team settings.

|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|true    |named   |false        |Settings|

#### **FieldValue**
If set, will return the team field values.

|Type      |Required|Position|PipelineInput|Aliases                 |
|----------|--------|--------|-------------|------------------------|
|`[Switch]`|true    |named   |false        |FieldValues<br/>AreaPath|

#### **Iteration**
If set, will return iterations for the team.

|Type      |Required|Position|PipelineInput|Aliases   |
|----------|--------|--------|-------------|----------|
|`[Switch]`|true    |named   |false        |Iterations|

#### **Board**
If set, will list team workboards.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|true    |named   |false        |Boards |

#### **SecurityGroup**
If set, will list the security groups.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

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
