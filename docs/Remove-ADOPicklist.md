Remove-ADOPicklist
------------------
### Synopsis
Removes Picklists and Widgets

---
### Description

Removes Picklists from Azure DevOps, or Removes Widgets from a Picklist in Azure Devops.

---
### Related Links
* [Get-ADOPicklist](Get-ADOPicklist.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/delete](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/delete)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOPicklist -Organization MyOrg -Orphan | Remove-ADOPicklist
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
#### **PicklistID**

The PicklistID.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Item**

A list of items to remove.
If this parameter is provided, the picklist items will be removed, and the picklist will not be deleted.
If this parameter is not provided, the picklist will not be deleted.



> **Type**: ```[String[]]```

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


* [Collections.Hashtable](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.Hashtable)




---
### Syntax
```PowerShell
Remove-ADOPicklist -Organization <String> -PicklistID <String> [-Item <String[]>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
