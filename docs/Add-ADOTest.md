
Add-ADOTest
-----------
### Synopsis
Creates tests in Azure DevOps.

---
### Description

Creates test plans, suites, points, and results in Azure DevOps or TFS.

---
### Related Links
* [Get-ADOProject](Get-ADOProject.md)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/test/runs/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/test/runs/list)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/test/results/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/test/results/list)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/test/test%20%20suites/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/test/test%20%20suites/list)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/testplan/test%20%20suites/get%20test%20suites%20for%20plan](https://docs.microsoft.com/en-us/rest/api/azure/devops/testplan/test%20%20suites/get%20test%20suites%20for%20plan)
---
### Parameters
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **TestPlan**

|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **TestSuite**

|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **ProjectID**

The project identifier.



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
### Outputs
PSDevOps.TestPlan


PSDevOps.TestRun


PSDevOps.TestSuite


PSDevOps.TestPoint


PSDevOps.TestCase


---
### Syntax
```PowerShell
Add-ADOTest -Organization <String> -TestPlan -ProjectID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Add-ADOTest -Organization <String> -TestSuite -ProjectID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---


