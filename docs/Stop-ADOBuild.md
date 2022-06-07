
Stop-ADOBuild
-------------
### Synopsis
Stops an Azure DevOps Build

---
### Description

Cancels a running Azure DevOps Build.

---
### Related Links
* [Start-ADOBuild](Start-ADOBuild.md)
* [Get-ADOBuild](Get-ADOBuild.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOBuild -Organization StartAutomating -Project PSDevOps -BuildResult None |
    Stop-ADOBuild
```

#### EXAMPLE 2
```PowerShell
Stop-ADOBuild -Organization StartAutomating -Project PSDevOps -BuildID 180
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


hashtable


---
### Syntax
```PowerShell
Stop-ADOBuild -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] -BuildID <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


