
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |1      |true (ByPropertyName)|
---
#### **Extension**

If provided, only return build steps matching this extension.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **Type**

If provided, only return build steps of a given type.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |3      |true (ByPropertyName)|
---
#### **BuildSystem**

If provided, only return build steps for a given build system.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |4      |true (ByPropertyName)|
---
### Outputs
PSDevOps.BuildStep


---
### Syntax
```PowerShell
Get-BuildStep [[-Name] <String>] [[-Extension] <String>] [[-Type] <String>] [[-BuildSystem] <String>] [<CommonParameters>]
```
---


