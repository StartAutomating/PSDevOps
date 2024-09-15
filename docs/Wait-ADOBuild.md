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
> EXAMPLE 1

```PowerShell
Get-ADOBuild -Organization MyOrg -Project MyProject -First 1 |
    Wait-ADOBuild
```

---

### Parameters
#### **Organization**
The Organization

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |1       |true (ByPropertyName)|Org    |

#### **Project**
The Project

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |2       |true (ByPropertyName)|

#### **BuildID**
One or more build IDs.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|true    |3       |true (ByPropertyName)|

#### **Server**
The server.  By default https://dev.azure.com/.

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |4       |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |5       |false        |

#### **PollingInterval**
The time to wait before each retry.  By default, 3 1/3 seconds.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[TimeSpan]`|false   |6       |false        |

#### **Timeout**
The timeout.  If provided, the function will wait no longer than the timeout.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[TimeSpan]`|false   |7       |false        |

---

### Outputs
* PSDevOps.Build

---

### Syntax
```PowerShell
Wait-ADOBuild [-Organization] <String> [-Project] <String> [-BuildID] <String[]> [[-Server] <Uri>] [[-ApiVersion] <String>] [[-PollingInterval] <TimeSpan>] [[-Timeout] <TimeSpan>] [<CommonParameters>]
```
