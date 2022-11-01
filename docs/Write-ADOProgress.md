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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **Status**

This text describes current state of the activity.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **Id**

Specifies an ID that distinguishes each progress bar from the others. Use this parameter when you are creating more than one progress bar in a single command.
If the progress bars do not have different IDs, they are superimposed instead of being displayed in a series.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
#### **PercentComplete**

Specifies the percentage of the activity that is completed.
Use the value -1 if the percentage complete is unknown or not applicable.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **SecondsRemaining**

Specifies the projected number of seconds remaining until the activity is completed.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **CurrentOperation**

This text describes the operation that is currently taking place.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ParentId**

Specifies the parent activity of the current activity.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Completed**

Indicates the progress timeline operation is completed.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Write-ADOProgress [-Activity] <String> [[-Status] <String>] [[-Id] <Int32>] [-PercentComplete <Int32>] [-SecondsRemaining <Int32>] [-CurrentOperation <String>] [-ParentId <Int32>] [-Completed] [<CommonParameters>]
```
---
