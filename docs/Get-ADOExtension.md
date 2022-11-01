Get-ADOExtension
----------------
### Synopsis
Gets Azure DevOps Extensions

---
### Description

Gets Extensions to Azure DevOps.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/list?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/list?view=azure-devops-rest-5.1)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/get?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/get?view=azure-devops-rest-5.1)



* [https://docs.microsoft.com/en-us/azure/devops/extend/develop/data-storage?view=azure-devops#how-settings-are-stored](https://docs.microsoft.com/en-us/azure/devops/extend/develop/data-storage?view=azure-devops#how-settings-are-stored)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOExtension -Organization StartAutomating
```

---
### Parameters
#### **Organization**

The organization.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ExtensionNameLike**

A wildcard of the extension name.  Only extensions where the Extension Name or ID matches the wildcard will be returned.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ExtensionNameMatch**

A regular expression of the extension name.  Only extensions where the Extension Name or ID matches the wildcard will be returned.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **PublisherNameLike**

A wildcard of the publisher name.  Only extensions where the Publisher Name or ID matches the wildcard will be returned.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **PublisherNameMatch**

A regular expression of the publisher name.  Only extensions where the Publisher Name or ID matches the wildcard will be returned.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **PublisherID**

The Publisher of the Extension.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ExtensionID**

The Extension Identifier.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DataCollection**

The data collection



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DataID**

The data identifier



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ScopeType**

The scope type.  By default, the value "default" (which maps to Project Collection)



Valid Values:

* Default
* Project
* User



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ScopeModifier**

The scope modifier.  By default, the value "current" (which maps to the current project collection or project)



Valid Values:

* Current
* Me



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AssetType**

A list of asset types



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IncludeDisabled**

If set, will include disabled extensions



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **InstallationIssue**

If set, will include extension installation issues



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **IncludeError**

If set, will include errors



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Contribution**

If set, will expand contributions.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Server**

The server.  By default https://dev.azure.com/.
To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1.
If targeting TFS, this will need to change to match your server version.
See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* PSDevOps.InstalledExtension




---
### Syntax
```PowerShell
Get-ADOExtension -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOExtension -Organization <String> [-ExtensionNameLike <String>] [-ExtensionNameMatch <String>] [-PublisherNameLike <String>] [-PublisherNameMatch <String>] [-AssetType <String[]>] [-IncludeDisabled] [-InstallationIssue] [-IncludeError] [-Contribution] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOExtension -Organization <String> [-ExtensionNameLike <String>] [-ExtensionNameMatch <String>] [-PublisherNameLike <String>] [-PublisherNameMatch <String>] -PublisherID <String> -ExtensionID <String> [-AssetType <String[]>] [-IncludeDisabled] [-InstallationIssue] [-IncludeError] [-Contribution] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOExtension -Organization <String> -PublisherID <String> -ExtensionID <String> -DataCollection <String> [-DataID <String>] [-ScopeType <String>] [-ScopeModifier <String>] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
