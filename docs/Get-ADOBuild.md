
Get-ADOBuild
------------
### Synopsis
Gets Azure DevOps Builds, Definitions, and associated information.

---
### Description

Gets Azure DevOps Builds or Definitions and associated information.

Gets builds by default.  To get build definitions, use -Definition

Given a -BuildID, we can can get associated information:

|Parameter | Effect                                       |
|----------|----------------------------------------------|
|-Artfiact      |  Get a list of all build artifacts      |
|-ChangeSet     |  Get the build's associated changeset   |
|-Log           |  Get a list of all build logs           |
|-LogID         |  Get the content of a specific LogID    |
|-Timeline      |  Gets the build timeline                |
|-BuildMetaData | Returns system metadata about the build |

Given a -Definition ID, we can get associated information:

|Parameter | Effect                                           |
|----------|--------------------------------------------------|
|-Status            | Gets the status of the build definition |
|-Metric            | Gets metrics about the build definition |
|-Revision          | Gets the revisions of a build definition|
|-DefinitionMetadata| Gets metadata about a build definition  |

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/artifacts/list?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/artifacts/list?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get%20build%20logs?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get%20build%20logs?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/timeline/get?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/timeline/get?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/properties/get%20build%20properties?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/properties/get%20build%20properties?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/get?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/get?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/properties/get%20definition%20properties?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/properties/get%20definition%20properties?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/metrics/get%20definition%20metrics?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/metrics/get%20definition%20metrics?view=azure-devops-rest-5.1)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOBuild -Organization StartAutomating -Project PSDevOps
```

#### EXAMPLE 2
```PowerShell
Get-ADOBuild -Organization StartAutomating -Project PSDevOps -Definition
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
#### **Server**

The server.  By default https://feeds.dev.azure.com/.



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |named  |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **BuildID**

Build ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Detail**

If set



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **BuildMetadata**

If set, returns system metadata about the -BuildID.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Artifact**

If set, will get artifacts from -BuildID.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|true    |named  |true (ByPropertyName)|
---
#### **Log**

If set, will get a list of logs associated with -BuildID



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **LogID**

If provided, will retreive the specific log content of -BuildID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **ChangeSet**

If set, will return the changeset associated with the build -BuildID.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Report**

If set, will return the build report associated with -BuildID.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Timeline**

If set, will return the timeline for build -BuildID



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **CodeCoverage**

If set, will return the code coverage associated with -BuildID



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Definition**

If set, will get build definitions.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **DefinitionID**

If set, will get a specific build by definition ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Status**

If set, will get the status of a defined build.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **DefinitionMetadata**

If set, will get definition properties



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Revision**

If set, will get revisions to a build definition.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Resource**

If set, will get authorized resources for a build definition.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **Metric**

If set, will get metrics about a build definition.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|true    |named  |false        |
---
#### **First**

If provided, will get the first N builds or build definitions



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[UInt32]```|false   |named  |false        |
---
#### **BranchName**

If provided, will only return builds for a given branch.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **Tag**

If provided, will only return builds one of these tags.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |named  |false        |
---
#### **After**

If provided, will only return builds queued after this point in time.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[DateTime]```|false   |named  |false        |
---
#### **Before**

If provided, will only return builds queued before this point in time.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[DateTime]```|false   |named  |false        |
---
#### **BuildResult**

If provided, will only return builds with this result.



Valid Values:

* Canceled
* Failed
* None
* Succeeded
* PartiallySucceeded
|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **DefinitionName**

Will only return build definitions with the specified name.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **BuiltAfter**

If provided, will only return build definitions that have been built after this date.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[DateTime]```|false   |named  |false        |
---
#### **NotBuiltSince**

If provided, will only return build definitions that have not been built since this date.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[DateTime]```|false   |named  |false        |
---
#### **IncludeAllProperty**

If set, will return extended properities of a build definition.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **IncludeLatestBuild**

If set, will include the latest build and latest completed build in a given build definition.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **DefinitionYAML**

If provided, will return build definition YAML.  No other information will be returned.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Outputs
PSDevOps.Build


PSDevOps.Build.Definition


PSDevOps.Build.Timeline


PSDevOps.Build.Change


PSDevOps.Build.Report


PSDevOps.Build.Artifact


PSDevOps.Build.CodeCoverage


---
### Syntax
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] [-First <UInt32>] [-BranchName <String>] [-Tag <String[]>] [-After <DateTime>] [-Before <DateTime>] [-BuildResult <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -CodeCoverage [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -Report [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -Timeline [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -Artifact [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -ChangeSet [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -LogID <String> [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -Log [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -BuildMetadata [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> [-Detail] [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -Definition [-First <UInt32>] [-DefinitionName <String>] [-BuiltAfter <DateTime>] [-NotBuiltSince <DateTime>] [-IncludeAllProperty] [-IncludeLatestBuild] [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> -Resource [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> -Status [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> -Revision [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> -Metric [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> -DefinitionMetadata [<CommonParameters>]
```
```PowerShell
Get-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> [-DefinitionYAML] [<CommonParameters>]
```
---


