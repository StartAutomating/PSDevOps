
Add-ADOIterationPath
--------------------
### Synopsis
Adds an Azure DevOps IterationPath

---
### Description

Adds an Azure DevOps IterationPath.  IterationPaths are used to logically group work items within a project.

---
### Related Links
* [Get-ADOIterationPath](Get-ADOIterationPath.md)
* [Remove-ADOIterationPath](Remove-ADOIterationPath.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Add-ADOIterationPath -Organization MyOrg -Project MyProject -IterationPath MyIterationPath
```

#### EXAMPLE 2
```PowerShell
Add-ADOIterationPath -Organization MyOrg -Project MyProject -IterationPath MyIterationPath\MyNestedPath
```

---
### Parameters
#### **Organization**

The Organization.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **Project**

The Project.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |2      |true (ByPropertyName)|
---
#### **IterationPath**

The IterationPath.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |3      |true (ByPropertyName)|
---
#### **StartDate**

The start date of the iteration.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[DateTime]```|false   |4      |true (ByPropertyName)|
---
#### **EndDate**

The end date of the iteration.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[DateTime]```|false   |5      |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |6      |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |7      |false        |
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
PSDevOps.IterationPath


---
### Syntax
```PowerShell
Add-ADOIterationPath [-Organization] <String> [-Project] <String> [-IterationPath] <String> [[-StartDate] <DateTime>] [[-EndDate] <DateTime>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---

