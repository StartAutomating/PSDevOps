
Update-ADOPicklist
------------------
### Synopsis
Updates picklists

---
### Description

Updates Picklists in Azure DevOps.

---
### Related Links
* [Get-ADOPicklist](Get-ADOPicklist.md)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/update](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/update)
---
### Examples
#### EXAMPLE 1
```PowerShell
Update-ADOPicklist -Organization MyOrg -PicklistName TShirtSize -Item S, M, L
```

---
### Parameters
#### **Organization**

The Organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **PicklistName**

The name of the picklist.  Providing this parameter will rename the picklist.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **DateType**

The data type of the picklist.



Valid Values:

* Double
* Integer
* String
|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **IsSuggested**

If set, will make the items in the picklist "suggested", and allow user input.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Item**

A list of items.  By default, these are the initial contents of the picklist.
If a PicklistID is provided, or -PicklistName already exists, will add these items to the picklist.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|true    |named  |true (ByPropertyName)|
---
#### **PicklistID**

The PicklistID of an existing picklist.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
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
PSDevOps.Picklist.Detail


---
### Syntax
```PowerShell
Update-ADOPicklist -Organization <String> [-PicklistName <String>] [-DateType <String>] [-IsSuggested] -Item <String[]> -PicklistID <String> [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


