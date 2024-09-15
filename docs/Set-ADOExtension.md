Set-ADOExtension
----------------

### Synopsis
Sets Azure DevOps Extension Data

---

### Description

Sets Data in Azure DevOps Extension Data Storage.

---

### Examples
> EXAMPLE 1

---

### Parameters
#### **Organization**
The organization.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **PublisherID**
The Publisher of the Extension.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **ExtensionID**
The Extension Identifier.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **DataCollection**
The data collection

|Type      |Required|Position|PipelineInput        |Aliases                                        |
|----------|--------|--------|---------------------|-----------------------------------------------|
|`[String]`|true    |named   |true (ByPropertyName)|TableName<br/>Table_Name<br/>DocumentCollection|

#### **DataID**
The data identifier

|Type      |Required|Position|PipelineInput        |Aliases              |
|----------|--------|--------|---------------------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|RowKey<br/>DocumentID|

#### **ScopeType**
The scope type.  By default, the value "default" (which maps to Project Collection)
Valid Values:

* Default
* Project
* User

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **ScopeModifier**
The scope modifier.  By default, the value "current" (which maps to the current project collection or project)
Valid Values:

* Current
* Me

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **InputObject**
The input object

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|true    |named   |true (ByValue)|

#### **Overwrite**
If set, will overwrite existing contents of storage.
If not set, new properties may be added to an existing

|Type      |Required|Position|PipelineInput        |Aliases             |
|----------|--------|--------|---------------------|--------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|NoMerge<br/>NoUpsert|

#### **Server**
The server.  By default https://extmgmt.dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|

#### **ApiVersion**
The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.

If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---

### Syntax
```PowerShell
Set-ADOExtension -Organization <String> -PublisherID <String> -ExtensionID <String> -DataCollection <String> [-DataID <String>] [-ScopeType <String>] [-ScopeModifier <String>] -InputObject <PSObject> [-Overwrite] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
