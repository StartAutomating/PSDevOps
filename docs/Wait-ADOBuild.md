Wait-ADOBuild
-------------
### Synopsis
Waits for Azure DevOps Builds

---
### Description

Waits for Azure DevOps or TFS Builds to complete, fail, get cancelled, or be postponed.

---
### Related Links
* [Get-ADOBuild](Get-ADOBuild.md)



* [Start-ADOBuild](Start-ADOBuild.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOBuild -Organization MyOrg -Project MyProject -First 1 |
    Wait-ADOBuild
```

---
### Parameters
#### **Organization**

The Organization



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
#### **BuildID**

One or more build IDs.



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://dev.azure.com/.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **PollingInterval**

The time to wait before each retry.  By default, 3 1/3 seconds.



> **Type**: ```[TimeSpan]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
#### **Timeout**

The timeout.  If provided, the function will wait no longer than the timeout.



> **Type**: ```[TimeSpan]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:false



---
### Outputs
* PSDevOps.Build




---
### Syntax
```PowerShell
Wait-ADOBuild [-Organization] <String> [-Project] <String> [-BuildID] <String[]> [[-Server] <Uri>] [[-ApiVersion] <String>] [[-PollingInterval] <TimeSpan>] [[-Timeout] <TimeSpan>] [<CommonParameters>]
```
---
