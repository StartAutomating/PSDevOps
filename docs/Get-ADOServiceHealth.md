Get-ADOServiceHealth
--------------------

### Synopsis
Gets the Azure DevOps Service Health

---

### Description

Gets the Service Health of Azure DevOps.

---

### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/status/health/get](https://docs.microsoft.com/en-us/rest/api/azure/devops/status/health/get)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ADOServiceHealth
```

---

### Parameters
#### **Service**
If provided, will query for health in a given geographic region.
Valid Values:

* Artifacts
* Boards
* Core services
* Other services
* Pipelines
* Repos
* Test Plans

|Type        |Required|Position|PipelineInput        |Aliases |
|------------|--------|--------|---------------------|--------|
|`[String[]]`|false   |1       |true (ByPropertyName)|Services|

#### **Geography**
If provided, will query for health in a given geographic region.
Valid Values:

* APAC
* AU
* BR
* CA
* EU
* IN
* UK
* US

|Type        |Required|Position|PipelineInput        |Aliases                           |
|------------|--------|--------|---------------------|----------------------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Geographies<br/>Region<br/>Regions|

#### **ApiVersion**
The api-version.  By default, 6.0

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Get-ADOServiceHealth [[-Service] <String[]>] [[-Geography] <String[]>] [[-ApiVersion] <String>] [<CommonParameters>]
```
