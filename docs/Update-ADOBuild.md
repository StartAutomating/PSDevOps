
Update-ADOBuild
---------------
### Synopsis
Updates builds and build definitions

---
### Description

Updates builds and build definitions in Azure DevOps.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/update%20build?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/update%20build?view=azure-devops-rest-5.1)
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/update?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/update?view=azure-devops-rest-5.1)
---
### Examples
#### EXAMPLE 1
```PowerShell
Update-ADOBuild -Organization MyOrg -Project MyProject -BuildID 1 -Build @{KeepForever=$true}
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

The server.  By default https://dev.azure.com/.



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |named  |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **BuildID**

The Build ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Build**

The updated build information.  This only needs to contain the changed information.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|true    |named  |true (ByPropertyName)|
---
#### **DefinitionID**

The Build Definition ID



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |named  |true (ByPropertyName)|
---
#### **Definition**

The new build definition.  This needs to contain the entire definition.



|Type            |Requried|Postion|PipelineInput |
|----------------|--------|-------|--------------|
|```[PSObject]```|true    |named  |true (ByValue)|
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
PSDevOps.Build


PSDevOps.Build.Definition


---
### Syntax
```PowerShell
Update-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> -Build <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Update-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -DefinitionID <String> -Definition <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


