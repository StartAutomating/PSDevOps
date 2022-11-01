New-ADOServiceEndpoint
----------------------
### Synopsis
Creates Azure DevOps Service Endpoints

---
### Description

Creates Service Endpoints in Azure DevOps.

Service Endpoints are used to connect an Azure DevOps project to one or more web services.

To see the types of service endpoints, use Get-ADOServiceEndpoint -GetEndpointType

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/create?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/create?view=azure-devops-rest-5.1)



---
### Examples
#### EXAMPLE 1
```PowerShell
New-ADOServiceEndpoint -Organization MyOrg -Project MyProject -Name MyGitHubConnection -Url https://github.com -Type GitHub -Authorization @{
    scheme = 'PersonalAccessToken'
    parameters = @{
        accessToken = $MyGitHubPersonalAccessToken
    }
} -PersonalAccessToken $MyAzureDevOpsPersonalAccessToken -Data @{pipelinesSourceProvider='github'}
```

---
### Parameters
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Name**

The name of the endpoint



> **Type**: ```[String]```

> **Required**: true

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **AdministratorsGroup**

Initial administrators of the endpoint



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **Authorization**

Endpoint authorization data



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **Data**

General endpoint data



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **ReadersGroup**

Initial readers of the endpoint



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **Type**

The endpoint type.  To see available endpoint types, use Get-ADOServiceEndpoint -GetEndpointType



> **Type**: ```[String]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

The endpoint description.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:true (ByPropertyName)



---
#### **Url**

The endpoint service URL.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 10

> **PipelineInput**:true (ByPropertyName)



---
#### **IsShared**

If set, the endpoint will be shared across projects



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 11

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: 12

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
* PSDevOps.ServiceEndpoint


* [Collections.Hashtable](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.Hashtable)




---
### Syntax
```PowerShell
New-ADOServiceEndpoint [-Organization] <String> [-Project] <String> [-Name] <String> [[-AdministratorsGroup] <PSObject>] [[-Authorization] <PSObject>] [[-Data] <PSObject>] [[-ReadersGroup] <PSObject>] [[-Type] <String>] [[-Description] <String>] [[-Url] <Uri>] [-IsShared] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
