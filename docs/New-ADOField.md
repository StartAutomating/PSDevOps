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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **ReferenceName**

The reference name of the field.  This is the name used in queries.
If not provided, the ReferenceName will Custom. + -Name (stripped of whitespace)



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



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



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

A description for the field.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **ValidValue**

A list of valid values.
If provided, an associated picklist will be created with these values.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **CanSortBy**

If set, the field can be used to sort.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IsQueryable**

If set, the field can be used in queries.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ReadOnly**

If set, the field will be read only.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AllowCustomValue**

If set, custom values can be provided into the field.
This is ignored if not used with -ValidValue.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: 9

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
* PSDevOps.Field




---
### Syntax
```PowerShell
New-ADOField [-Name] <String> [[-ReferenceName] <String>] [[-Type] <String>] [[-Description] <String>] [[-ValidValue] <String[]>] [-CanSortBy] [-IsQueryable] [-ReadOnly] [-AllowCustomValue] [-Organization] <String> [[-Project] <String>] [[-Server] <Uri>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
