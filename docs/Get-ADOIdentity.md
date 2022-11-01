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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **AceDictionary**

A dictionary of Access Control Entries



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Descriptors**

A list of descriptors



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **DescriptorBatchSize**

The maximum number of specific descriptors to request in one batch.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **Membership**

If set, will get membership information.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Recurse**

If set, will recursively expand any group memberships discovered.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Filter**

The filter used for a query



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **SearchType**

The search type.  Can be:  AccountName, DisplayName, MailAddress, General, LocalGroupName



Valid Values:

* AccountName
* DisplayName
* MailAddress
* General
* LocalGroupName



> **Type**: ```[String]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
#### **ApiVersion**

The api version.  By default, 6.0.
This API does not exist in TFS.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:false



---
### Outputs
* PSDevOps.Team


* PSDevOps.TeamMember




---
### Syntax
```PowerShell
Get-ADOIdentity [-Organization] <String> [[-AceDictionary] <PSObject>] [[-Descriptors] <String[]>] [[-DescriptorBatchSize] <Int32>] [-Membership] [-Recurse] [[-Filter] <String>] [[-SearchType] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```
---
