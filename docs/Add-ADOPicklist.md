Add-ADOPicklist
---------------
### Synopsis
Creates Picklists

---
### Description

Creates Picklists in Azure DevOps.

---
### Related Links
* [Get-ADOPicklist](Get-ADOPicklist.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/create](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/create)



---
### Examples
#### EXAMPLE 1
```PowerShell
Add-ADOPicklist -Organization MyOrg -PicklistName TShirtSize -Item S, M, L, XL
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
#### **PicklistName**

The name of the picklist



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **DateType**

The data type of the picklist.  By default, String.



Valid Values:

* Double
* Integer
* String



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IsSuggested**

If set, will make the items in the picklist "suggested", and allow user input.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Item**

A list of items.  By default, these are the initial contents of the picklist.
If a PicklistID is provided, or -PicklistName already exists, will add these items to the picklist.



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PicklistID**

The PicklistID of an existing picklist.



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
* PSDevOps.Picklist.Detail




---
### Syntax
```PowerShell
Add-ADOPicklist -Organization <String> -PicklistName <String> [-DateType <String>] [-IsSuggested] -Item <String[]> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Add-ADOPicklist -Organization <String> [-DateType <String>] [-IsSuggested] -Item <String[]> -PicklistID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
