Disconnect-ADO
--------------
### Synopsis
Disconnects from Azure DevOps

---
### Description

Disconnects from Azure DevOps, clearing parameter value defaults and cached access tokens.

---
### Related Links
* [Connect-ADO](Connect-ADO.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Disconnect-ADO
```

---
### Parameters
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


* [Management.Automation.PSObject](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSObject)




---
### Syntax
```PowerShell
Disconnect-ADO [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
