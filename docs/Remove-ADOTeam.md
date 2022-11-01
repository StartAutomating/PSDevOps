Remove-ADOTeam
--------------
### Synopsis
Removes Azure DevOps Teams

---
### Description

Removes teams from Azure DevOps or TFS

---
### Related Links
* [New-ADOTeam](New-ADOTeam.md)



* [Get-ADOTeam](Get-ADOTeam.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Remove-ADOTeam -Organization StartAutomating -Project PSDevOps -TeamID Stakeholders -WhatIf
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

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TeamID**

The Team Identifier



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

The api version.  By default, 5.1.
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
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)


* [Collections.IDictionary](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.IDictionary)




---
### Syntax
```PowerShell
Remove-ADOTeam -Organization <String> -Project <String> -TeamID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
