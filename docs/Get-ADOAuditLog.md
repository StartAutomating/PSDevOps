Get-ADOAuditLog
---------------

### Synopsis
Gets the Azure DevOps Audit Log

---

### Description

Gets the Azure DevOps Audit Log for a Given Organization

---

### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/audit/audit-log/query](https://docs.microsoft.com/en-us/rest/api/azure/devops/audit/audit-log/query)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ADOAuditLog
```

---

### Parameters
#### **Organization**
The Organization

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **BatchSize**
The size of the batch of audit log entries.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|

#### **StartTime**
The start time.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[DateTime]`|false   |named   |true (ByPropertyName)|

#### **EndTime**
The end time.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[DateTime]`|false   |named   |true (ByPropertyName)|

#### **ApiVersion**
The api-version.  By default, 7.1-preview.1

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Get-ADOAuditLog -Organization <String> [-BatchSize <Int32>] [-StartTime <DateTime>] [-EndTime <DateTime>] [-ApiVersion <String>] [<CommonParameters>]
```
