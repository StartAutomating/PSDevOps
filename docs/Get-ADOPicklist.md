
Get-ADOPicklist
---------------
### Synopsis
Gets picklists from Azure DevOps.

---
### Description

Gets picklists from Azure DevOps.

Picklists are lists of values that can be associated with a field, for example, a list of T-shirt sizes.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/list)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/get](https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/get)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOPicklist -Organization StartAutomating -PersonalAccessToken $pat
```

#### EXAMPLE 2
```PowerShell
Get-ADOPicklist -Organization StartAutomating
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **PickListID**

The Picklist Identifier.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **PicklistName**

The name of the picklist



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Orphan**

If set, will return orphan picklists.  These picklists are not associated with any field.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
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
### Outputs
PSDevOps.Project


PSDevOps.Property


---
### Syntax
```PowerShell
Get-ADOPicklist -Organization <String> [-PicklistName <String>] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPicklist -Organization <String> [-PicklistName <String>] -Orphan [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOPicklist -Organization <String> -PickListID <String> [-PicklistName <String>] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---


