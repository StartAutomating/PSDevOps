Set-ADOBuild
------------
### Synopsis
Sets ADO Build information

---
### Description

Sets the Azure DevOps Build information

---
### Related Links
* [https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands)



---
### Examples
#### EXAMPLE 1
```PowerShell
Set-ADOBuild -Log .\MyLog.log
```

#### EXAMPLE 2
```PowerShell
Set-ADOBuild -BuildNumber 21
```

#### EXAMPLE 3
```PowerShell
Set-ADOBuild -Tag TestPassed, CodeCoveragePassed
```

#### EXAMPLE 4
```PowerShell
Set-ADOBuild -ReleaseName NewRelease
```

---
### Parameters
#### **BuildNumber**

A new build number (or identifier)



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Tag**

One or more tags for this build



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ReleaseName**

The name of the release



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **EnvironmentPath**

Adds a location to the environment path



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Set-ADOBuild [-BuildNumber <String>] [-Tag <String[]>] [-ReleaseName <String>] [-EnvironmentPath <String>] [<CommonParameters>]
```
---
