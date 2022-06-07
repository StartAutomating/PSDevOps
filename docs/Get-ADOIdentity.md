
Get-ADOIdentity
---------------
### Synopsis
Gets Azure DevOps Identities

---
### Description

Gets Identities from Azure Devops.  Identities can be either users or groups.

---
### Related Links
* [Get-ADOUser](Get-ADOUser.md)
* [Get-ADOTeam](Get-ADOTeam.md)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/ims/identities/read%20identities](https://docs.microsoft.com/en-us/rest/api/azure/devops/ims/identities/read%20identities)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOIdentity -Organization StartAutomating -Filter 'GitHub'
```

---
### Parameters
#### **Organization**

The Organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **AceDictionary**

A dictionary of Access Control Entries



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |2      |true (ByPropertyName)|
---
#### **Descriptors**

A list of descriptors



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |3      |true (ByPropertyName)|
---
#### **DescriptorBatchSize**

The maximum number of specific descriptors to request in one batch.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |4      |false        |
---
#### **Membership**

If set, will get membership information.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Recurse**

If set, will recursively expand any group memberships discovered.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **Filter**

The filter used for a query



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |5      |false        |
---
#### **SearchType**

The search type.  Can be:  AccountName, DisplayName, MailAddress, General, LocalGroupName



Valid Values:

* AccountName
* DisplayName
* MailAddress
* General
* LocalGroupName
|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |6      |false        |
---
#### **ApiVersion**

The api version.  By default, 6.0.
This API does not exist in TFS.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |7      |false        |
---
### Outputs
PSDevOps.Team


PSDevOps.TeamMember


---
### Syntax
```PowerShell
Get-ADOIdentity [-Organization] <String> [[-AceDictionary] <PSObject>] [[-Descriptors] <String[]>] [[-DescriptorBatchSize] <Int32>] [-Membership] [-Recurse] [[-Filter] <String>] [[-SearchType] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```
---


