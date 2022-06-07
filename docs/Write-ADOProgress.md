
Write-ADOProgress
-----------------
### Synopsis
Writes AzureDevOps Progress

---
### Description

Writes a progress record to the Azure DevOps pipeline.

---
### Related Links
* [Write-ADOError](Write-ADOError.md)
* [Write-ADOWarning](Write-ADOWarning.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Write-ADOProgress -Activity "Doing Stuff" -Status "And Things" -PercentComplete 50
```

---
### Parameters
#### **Activity**

This text describes the activity whose progress is being reported.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|true    |1      |false        |
---
#### **Status**

This text describes current state of the activity.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |2      |false        |
---
#### **Id**

Specifies an ID that distinguishes each progress bar from the others. Use this parameter when you are creating more than one progress bar in a single command.
If the progress bars do not have different IDs, they are superimposed instead of being displayed in a series.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |3      |false        |
---
#### **PercentComplete**

Specifies the percentage of the activity that is completed.
Use the value -1 if the percentage complete is unknown or not applicable.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
#### **SecondsRemaining**

Specifies the projected number of seconds remaining until the activity is completed.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
#### **CurrentOperation**

This text describes the operation that is currently taking place.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |named  |false        |
---
#### **ParentId**

Specifies the parent activity of the current activity.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
#### **Completed**

Indicates the progress timeline operation is completed.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Outputs
System.String


---
### Syntax
```PowerShell
Write-ADOProgress [-Activity] <String> [[-Status] <String>] [[-Id] <Int32>] [-PercentComplete <Int32>] [-SecondsRemaining <Int32>] [-CurrentOperation <String>] [-ParentId <Int32>] [-Completed] [<CommonParameters>]
```
---


