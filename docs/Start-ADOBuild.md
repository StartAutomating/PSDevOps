Start-ADOBuild
--------------
### Synopsis
Starts an Azure DevOps Build

---
### Description

Starts a build in Azure DevOps, using an existing BuildID,

---
### Related Links
* [Get-ADOBuild](Get-ADOBuild.md)



* [Stop-ADOBuild](Stop-ADOBuild.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/queues](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/queues)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOBuild -Definition -Organization StartAutomating -Project PSDevOps |
    Start-ADOBuild -WhatIf
```

---
### Parameters
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **BuildID**

The Build ID



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
#### **DefinitionName**

The Build Definition Name



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SourceBranch**

The source branch (the branch used for the build).



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SourceVersion**

The source version (the commit used for the build).



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Parameter**

The build parameters



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



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
* PSDevOps.Build


* [Collections.Hashtable](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.Hashtable)




---
### Syntax
```PowerShell
Start-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> [-SourceBranch <String>] [-SourceVersion <String>] [-Parameter <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Start-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> [-SourceBranch <String>] [-SourceVersion <String>] [-Parameter <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Start-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionName <String> [-SourceBranch <String>] [-SourceVersion <String>] [-Parameter <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
