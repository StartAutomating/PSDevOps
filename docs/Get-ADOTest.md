Get-ADOTest
-----------
### Synopsis
Gets tests from Azure DevOps.

---
### Description

Gets test plans, suites, points, and results from Azure DevOps or TFS.

---
### Related Links
* [Get-ADOProject](Get-ADOProject.md)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/test/runs/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/test/runs/list)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/test/results/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/test/results/list)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/test/test%20%20suites/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/test/test%20%20suites/list)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/testplan/test%20%20suites/get%20test%20suites%20for%20plan](https://docs.microsoft.com/en-us/rest/api/azure/devops/testplan/test%20%20suites/get%20test%20suites%20for%20plan)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOProject -Organization StartAutomating -Project PSDevOps |
    Get-ADOTest -Run
```

---
### Parameters
#### **ProjectID**

The project identifier.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TestRun**

If set, will return the test runs associated with a project.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **TestRunID**

If set, will return results related to a specific test run.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TestPlan**

If set, will return the test plans associated with a project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **TestPlanID**

If set, will return results related to a specific test plan.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TestVariable**

If set, will return the test variables associated with a project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **TestConfiguration**

If set, will return the test variables associated with a project.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **TestSuite**

If set, will list test suites related to a plan.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **TestSuiteID**

If set, will return results related to a particular test suite.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TestPoint**

If set, will return test points within a suite.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **TestResult**

If set, will return test results within a run.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **First**

If set, will return the first N results within a test run.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Total**

If provided, will return the continue to return results of the maximum batch size until the total is reached.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Skip**

If set, will return the skip N results within a test run.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Outcome**

If provided, will only return test results with one of the provided outcomes.



Valid Values:

* Unspecified
* None
* Passed
* Failed
* Inconclusive
* Timeout
* Aborted
* Blocked
* NotExecuted
* Warning
* Error
* NotApplicable
* Passed
* InProgress
* NotImpacted



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ResultDetail**

Details to include with the test results.



Valid Values:

* None
* Iterations
* WorkItems



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **TestAttachment**

If set, will return test attachments to a run.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

If set, will always retrieve fresh data.
By default, cached data will be returned.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



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
### Outputs
* PSDevOps.Project


* PSDevOps.Property




---
### Syntax
```PowerShell
Get-ADOTest -ProjectID <String> [-TestRun] -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestRunID <String> -TestResult [-First <Int32>] [-Total <Int32>] [-Skip <Int32>] [-Outcome <String[]>] [-ResultDetail <String[]>] -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestRunID <String> -TestAttachment -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestRunID <String> -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestPlan -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestPlanID <String> -TestSuiteID <String> -TestPoint -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestPlanID <String> -TestSuite -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestPlanID <String> -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestVariable -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestConfiguration -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOTest -ProjectID <String> -TestSuiteID <String> -Organization <String> [-Force] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
