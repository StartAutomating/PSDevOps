Get-ADOProject
--------------

### Synopsis
Gets projects from Azure DevOps.

---

### Description

Gets projects from Azure DevOps or TFS.

---

### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/list)

* [https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/list)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ADOProject -Organization StartAutomating -PersonalAccessToken $pat
```
> EXAMPLE 2

```PowerShell
Get-ADOProject -Organization StartAutomating -Project PSDevOps
```
> EXAMPLE 3

```PowerShell
Get-ADOProject -Organization StartAutomating -Project PSDevOps |
    Get-ADOProject -Metadata
```

---

### Parameters
#### **Project**
The project name.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **ProjectID**
The project identifier.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Metadata**
If set, will get project metadta

|Type      |Required|Position|PipelineInput|Aliases                |
|----------|--------|--------|-------------|-----------------------|
|`[Switch]`|true    |named   |false        |Property<br/>Properties|

#### **ProcessConfiguration**
If set, will return the process configuration of a project.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **PolicyConfiguration**
If set, will return the policy configuration of a project.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **PolicyType**
If set, will return the policy types available in a given project.

|Type      |Required|Position|PipelineInput|Aliases    |
|----------|--------|--------|-------------|-----------|
|`[Switch]`|true    |named   |false        |PolicyTypes|

#### **Plan**
If set, will return the plans related to a project.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **TestRun**
If set, will return the test runs associated with a project.

|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|true    |named   |false        |TestRuns|

#### **TestPlan**
If set, will return the test plans associated with a project.

|Type      |Required|Position|PipelineInput|Aliases  |
|----------|--------|--------|-------------|---------|
|`[Switch]`|true    |named   |false        |TestPlans|

#### **TestVariable**
If set, will return the test variables associated with a project.

|Type      |Required|Position|PipelineInput|Aliases      |
|----------|--------|--------|-------------|-------------|
|`[Switch]`|true    |named   |false        |TestVariables|

#### **TestConfiguration**
If set, will return the test variables associated with a project.

|Type      |Required|Position|PipelineInput|Aliases           |
|----------|--------|--------|-------------|------------------|
|`[Switch]`|true    |named   |false        |TestConfigurations|

#### **PlanID**
If set, will a specific project plan.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |named   |false        |

#### **DeliveryTimeline**
If set, will return the project delivery timeline associated with a given planID.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |named   |false        |

#### **Wiki**
If set, will return any wikis associated with the project.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **Board**
If set, will return any boards associated with the project.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |

#### **Release**
If set, will return releases associated with the project.

|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|true    |named   |false        |Releases|

#### **PendingApproval**
If set, will return pending approvals associated with the project.

|Type      |Required|Position|PipelineInput|Aliases         |
|----------|--------|--------|-------------|----------------|
|`[Switch]`|true    |named   |false        |PendingApprovals|

#### **Organization**
The Organization

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|Org    |

#### **Server**
The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1-preview.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

---

### Outputs
* PSDevOps.Project

* PSDevOps.Property

---

### Syntax
```PowerShell
Get-ADOProject -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -Project <String> -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Board -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -TestConfiguration -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -TestVariable -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -PendingApproval -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Release -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -TestPlan -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -TestRun -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Wiki -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -PolicyConfiguration -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -PolicyType -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -PlanID <String> -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Plan -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -ProcessConfiguration -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Metadata -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -ProjectID <String> -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOProject -PlanID <String> -DeliveryTimeline <String> -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
