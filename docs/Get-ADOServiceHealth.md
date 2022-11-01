Get-ADOServiceHealth
--------------------
### Synopsis
Gets the Azure DevOps Service Health

---
### Description

Gets the Service Health of Azure DevOps.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/status/health/get](https://docs.microsoft.com/en-us/rest/api/azure/devops/status/health/get)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOServiceHealth
```

---
### Parameters
#### **Service**

If provided, will query for health in a given geographic region.



Valid Values:

* Artifacts
* Boards
* Core services
* Other services
* Pipelines
* Repos
* Test Plans



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Geography**

If provided, will query for health in a given geographic region.



Valid Values:

* APAC
* AU
* BR
* CA
* EU
* IN
* UK
* US



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api-version.  By default, 6.0



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
### Syntax
```PowerShell
Get-ADOServiceHealth [[-Service] <String[]>] [[-Geography] <String[]>] [[-ApiVersion] <String>] [<CommonParameters>]
```
---
