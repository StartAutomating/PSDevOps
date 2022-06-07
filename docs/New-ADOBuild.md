
New-ADOBuild
------------
### Synopsis
Creates Azure DevOps Build Definitions

---
### Description

Creates Build Definitions in Azure DevOps.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/create](https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/create)
---
### Examples
#### EXAMPLE 1
```PowerShell
New-ADOBuild -Organization StartAutomating -Project PSDevops -Name PSDevOps_CI -Repository @{
    id = 'StartAutomating/PSDevOps'
    type = 'GitHub'
    name = 'StartAutomating/PSDevOps'
    url  = 'https://github.com/StartAutomating/PSDevOps.git'
    defaultBranch = 'master'
    properties = @{
        connectedServiceId  = '2b65e3be-c457-4d61-b457-d883fb231ff2'
    }
} -YAMLFilename azure-pipelines.yml
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

The Project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |2      |true (ByPropertyName)|
---
#### **Name**

The name of the build.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |3      |true (ByPropertyName)|
---
#### **Path**

The folder path of the definition.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |4      |true (ByPropertyName)|
---
#### **YAMLFileName**

The path to a YAML file containing the build definition



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |5      |true (ByPropertyName)|
---
#### **Comment**

A comment about the build defintion revision.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |6      |true (ByPropertyName)|
---
#### **Description**

A description of the build definition.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |7      |true (ByPropertyName)|
---
#### **DropLocation**

The drop location for the build



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |8      |true (ByPropertyName)|
---
#### **BuildNumberFormat**

The build number format



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |9      |true (ByPropertyName)|
---
#### **Repository**

The repository used by the build definition.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|true    |10     |true (ByPropertyName)|
---
#### **Queue**

The queue used by the build definition.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[PSObject]```|false   |11     |true (ByPropertyName)|
---
#### **Demand**

A collection of demands for the build definition.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |12     |true (ByPropertyName)|
---
#### **Variable**

A collection of variables for the build definition.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |13     |true (ByPropertyName)|
---
#### **Secret**

A collection of secrets for the build definition.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[IDictionary]```|false   |14     |true (ByPropertyName)|
---
#### **Tag**

A list of tags for the build definition.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |15     |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |16     |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |17     |false        |
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
PSDevOps.Build.Definition


---
### Syntax
```PowerShell
New-ADOBuild [-Organization] <String> [-Project] <String> [-Name] <String> [[-Path] <String>] [[-YAMLFileName] <String>] [[-Comment] <String>] [[-Description] <String>] [[-DropLocation] <String>] [[-BuildNumberFormat] <String>] [-Repository] <PSObject> [[-Queue] <PSObject>] [[-Demand] <IDictionary>] [[-Variable] <IDictionary>] [[-Secret] <IDictionary>] [[-Tag] <String[]>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


