
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **PersonalAccessToken**

The Personal Access Token.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **UseDefaultCredentials**

If set, will use default credentials when connecting.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Credential**

The credential used to connect.



|Type                |Requried|Postion|PipelineInput        |
|--------------------|--------|-------|---------------------|
|```[PSCredential]```|false   |3      |true (ByPropertyName)|
---
#### **Server**

The Server.  If this points to a TFS server, it should be the root TFS url, i.e. http://localhost:8080/tfs



|Type       |Requried|Postion|PipelineInput        |
|-----------|--------|-------|---------------------|
|```[Uri]```|false   |4      |true (ByPropertyName)|
---
### Outputs
PSDevOps.Connection


---
### Syntax
```PowerShell
Connect-ADO [-Organization] <String> [[-PersonalAccessToken] <String>] [-UseDefaultCredentials] [[-Credential] <PSCredential>] [[-Server] <Uri>] [<CommonParameters>]
```
---


