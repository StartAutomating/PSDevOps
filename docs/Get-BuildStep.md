Get-BuildStep
-------------
### Synopsis
Gets BuildSteps

---
### Description

Gets Build Steps.

Build Steps are scripts or data fragments used to compose a build.

---
### Related Links
* [Import-BuildStep](Import-BuildStep.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-BuildStep
```

---
### Parameters
#### **Name**

If provided, only return build steps that are like this name.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Extension**

If provided, only return build steps matching this extension.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Type**

If provided, only return build steps of a given type.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **BuildSystem**

If provided, only return build steps for a given build system.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* PSDevOps.BuildStep




---
### Syntax
```PowerShell
Get-BuildStep [[-Name] <String>] [[-Extension] <String>] [[-Type] <String>] [[-BuildSystem] <String>] [<CommonParameters>]
```
---
