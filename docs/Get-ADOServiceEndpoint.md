
Get-ADOServiceEndpoint
----------------------
### Synopsis
Gets Azure DevOps Service Endpoints

---
### Description

Gets Service Endpoints from Azure DevOps.

Service Endpoints are used to connect an Azure DevOps project to one or more web services.

To see the types of service endpoints, use Get-ADOServiceEndpoint -GetEndpointType

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/get%20service%20endpoints?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/get%20service%20endpoints?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/get?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/get?view=azure-devops-rest-5.1)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOServiceEndpoint -Organization MyOrg -Project MyProject -PersonalAccessToken $myPersonalAccessToken
```

#### EXAMPLE 2
```PowerShell
Get-ADOServiceEndpoint -Organization MyOrg -GetEndpointType -PersonalAccessToken $myPersonalAccessToken
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Project**

The Project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **EndpointID**

The Endpoint ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **History**

If set, will get the execution history of the endpoint.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **GetEndpointType**

If set, will get the types of endpoints.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
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
PSDevOps.ServiceEndpoint


StartAutomating.PSDevOps.ServiceEndpoint.History


StartAutomating.PSDevOps.ServiceEndpoint.Type


---
### Syntax
```PowerShell
Get-ADOServiceEndpoint -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceEndpoint -Organization <String> -GetEndpointType [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceEndpoint -Organization <String> -Project <String> -EndpointID <String> -History [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceEndpoint -Organization <String> -Project <String> -EndpointID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---


