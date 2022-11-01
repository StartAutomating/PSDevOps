Remove-ADOArtifactFeed
----------------------
### Synopsis
Removes artifact feeds from Azure DevOps

---
### Description

Removes artifact feeds from Azure DevOps.  Artifact feeds are used to publish packages.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOArtifactFeed -Organization MyOrg -Project MyProject -FeedId MyFeed |
    Remove-ADOArtifactFeed
```

---
### Parameters
#### **Organization**

The Organization



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The Project



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FeedID**

The Feed Name or ID
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ViewID**

The View Name or ID
?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **View**

If set, will remove a view.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The server.  By default https://feeds.dev.azure.com/.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApiVersion**

The api version.  By default, 5.1-preview.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)


* [Collections.IDictionary](https://learn.microsoft.com/en-us/dotnet/api/System.Collections.IDictionary)




---
### Syntax
```PowerShell
Remove-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-ViewID <String>] [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Remove-ADOArtifactFeed -Organization <String> [-Project <String>] -FeedID <String> [-ViewID <String>] -View [-Server <Uri>] [-ApiVersion <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
