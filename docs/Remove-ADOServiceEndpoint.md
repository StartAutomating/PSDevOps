
Remove-ADOServiceEndpoint
-------------------------
### Synopsis
Removes Azure DevOps Service Endpoints

---
### Description

Removes Azure DevOps Service Endpoints.
Service Endpoints allow you to connect an Azure DevOps project with to one or more web services.

---
### Related Links
* [Get-ADOServiceEndpoint](Get-ADOServiceEndpoint.md)
* [New-ADOServiceEndpoint](New-ADOServiceEndpoint.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
# clears the service endpoints for MyOrg/MyProject.  -PersonalAccessToken must be provided
Get-ADOServiceEndpoint -Organization MyOrg -Project MyProject | Remove-ADOServiceEndpoint
```

---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Project**

The Project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |2      |true (ByPropertyName)|
---
#### **EndpointID**

The Endpoint ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |3      |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |4      |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |5      |false        |
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
System.Nullable


System.Collections.Hashtable


---
### Syntax
```PowerShell
Remove-ADOServiceEndpoint [-Organization] <String> [-Project] <String> [-EndpointID] <String> [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


