Connect-ADO
-----------
### Synopsis
Connects to Azure DeVOps

---
### Description

Connects the current PowerShell session to Azure DeVOps or a Team Foundation Server.

Information passed to Connect-ADO will be used as the default parameters to all -ADO* commands from PSDevOps.

PersonalAccessTokens will be cached separately to improve security.

---
### Related Links
* [Disconnect-ADO](Disconnect-ADO.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Connect-ADO -Organization StartAutomating -PersonalAccessToken $myPat
```

---
### Parameters
#### **Organization**

The organization.
When connecting to TFS, this is the Project Collection.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **PersonalAccessToken**

The Personal Access Token.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **UseDefaultCredentials**

If set, will use default credentials when connecting.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Credential**

The credential used to connect.



> **Type**: ```[PSCredential]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Server**

The Server.  If this points to a TFS server, it should be the root TFS url, i.e. http://localhost:8080/tfs



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **NoCache**

If set, will not cache teams and projects in order to create argument completers.
If you are using a restricted Personal Access Token, this may prevent errors.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* PSDevOps.Connection




---
### Syntax
```PowerShell
Connect-ADO [-Organization] <String> [[-PersonalAccessToken] <String>] [-UseDefaultCredentials] [[-Credential] <PSCredential>] [[-Server] <Uri>] [-NoCache] [<CommonParameters>]
```
---
