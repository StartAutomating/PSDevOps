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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Name**

The name of the build.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Path**

The folder path of the definition.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **YAMLFileName**

The path to a YAML file containing the build definition



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **Comment**

A comment about the build defintion revision.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

A description of the build definition.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **DropLocation**

The drop location for the build



> **Type**: ```[String]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildNumberFormat**

The build number format



> **Type**: ```[String]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:true (ByPropertyName)



---
#### **Repository**

The repository used by the build definition.



> **Type**: ```[PSObject]```

> **Required**: true

> **Position**: 10

> **PipelineInput**:true (ByPropertyName)



---
#### **Queue**

The queue used by the build definition.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 11

> **PipelineInput**:true (ByPropertyName)



---
#### **Demand**

A collection of demands for the build definition.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 12

> **PipelineInput**:true (ByPropertyName)



---
#### **Variable**

A collection of variables for the build definition.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 13

> **PipelineInput**:true (ByPropertyName)



---
#### **Secret**

A collection of secrets for the build definition.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 14

> **PipelineInput**:true (ByPropertyName)



---
#### **Tag**

A list of tags for the build definition.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 15

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 16

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: 17

> **PipelineInput**:false



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
* PSDevOps.Build.Definition




---
### Syntax
```PowerShell
New-ADOBuild [-Organization] <String> [-Project] <String> [-Name] <String> [[-Path] <String>] [[-YAMLFileName] <String>] [[-Comment] <String>] [[-Description] <String>] [[-DropLocation] <String>] [[-BuildNumberFormat] <String>] [-Repository] <PSObject> [[-Queue] <PSObject>] [[-Demand] <IDictionary>] [[-Variable] <IDictionary>] [[-Secret] <IDictionary>] [[-Tag] <String[]>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
