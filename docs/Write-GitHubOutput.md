Write-GitHubOutput
------------------
### Synopsis
Writes Git Output

---
### Description

Writes formal Output to a GitHub step.

This output can be referenced in subsequent steps.

---
### Related Links
* [Write-GitHubError](Write-GitHubError.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Write-GitHubOutput @{
    key = 'value'
}
```

#### EXAMPLE 2
```PowerShell
Get-Random -Minimum 1 -Maximum 10 | Write-GitHubHubOutput -Name RandomNumber
```

---
### Parameters
#### **InputObject**

The InputObject.  Values will be converted to a JSON array.



> **Type**: ```[PSObject]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Name**

The Name of the Output.  By default, 'Output'.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **Depth**

The JSON serialization depth.  By default, 10 levels.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Write-GitHubOutput [-InputObject] <PSObject> [[-Name] <String>] [[-Depth] <Int32>] [<CommonParameters>]
```
---
