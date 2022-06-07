
New-ADOField
------------
### Synopsis
Creates new fields in Azure DevOps

---
### Description

Creates new work item fields in Azure DevOps or Team Foundation Server.

---
### Related Links
* [Invoke-ADORestAPI](Invoke-ADORestAPI.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
New-ADOField -Name Verb -ReferenceName Cmdlet.Verb -Description "The PowerShell Verb" -ValidValue (Get-Verb | Select-Object -ExpandProperty Verb | Sort-Object) -Organization MyOrganization
```

#### EXAMPLE 2
```PowerShell
New-ADOField -Name IsDCR -Type Boolean -Description "Is this a direct custom request?" -Organization MyOrganization
```

---
### Parameters
#### **Name**

The friendly name of the field



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **ReferenceName**

The reference name of the field.  This is the name used in queries.
If not provided, the ReferenceName will Custom. + -Name (stripped of whitespace)



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **Type**

The type of the field.

This can be any of the following:
* boolean
* dateTime
* double
* guid
* history
* html
* identity
* integer
* plainText
* string
* treePath



Valid Values:

* boolean
* dateTime
* double
* guid
* history
* html
* identity
* integer
* picklistDouble
* picklistInteger
* picklistString
* plainText
* string
* treePath
|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |3      |true (ByPropertyName)|
---
#### **Description**

A description for the field.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |4      |true (ByPropertyName)|
---
#### **ValidValue**

A list of valid values.
If provided, an associated picklist will be created with these values.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |5      |true (ByPropertyName)|
---
#### **CanSortBy**

If set, the field can be used to sort.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **IsQueryable**

If set, the field can be used in queries.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **ReadOnly**

If set, the field will be read only.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **AllowCustomValue**

If set, custom values can be provided into the field.
This is ignored if not used with -ValidValue.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Organization**

The Organization



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |6      |true (ByPropertyName)|
---
#### **Project**

The Project



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |7      |true (ByPropertyName)|
---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |8      |true (ByPropertyName)|
---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |9      |false        |
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
PSDevOps.Field


---
### Syntax
```PowerShell
New-ADOField [-Name] <String> [[-ReferenceName] <String>] [[-Type] <String>] [[-Description] <String>] [[-ValidValue] <String[]>] [-CanSortBy] [-IsQueryable] [-ReadOnly] [-AllowCustomValue] [-Organization] <String> [[-Project] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---


