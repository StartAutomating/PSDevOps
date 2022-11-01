Remove-ADOBuild
---------------
### Synopsis
Removes builds and build definitions

---
### Description

Removes builds and build definitions from Azure DevOps.

---
### Related Links
* [Get-ADOBuild](Get-ADOBuild.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/delete?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/delete?view=azure-devops-rest-5.1)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/delete?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/delete?view=azure-devops-rest-5.1)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOBuild -Organization StartAutomating -Project PSDevOps |
    Select-Object -Last 1 |
    Remove-ADOBuild
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

The server.  By default https://feeds.dev.azure.com/.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



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
Remove-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
