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
> EXAMPLE 1

```PowerShell
Connect-ADO -Organization StartAutomating -PersonalAccessToken $myPat
```

---

### Parameters
#### **Organization**
The organization.
When connecting to TFS, this is the Project Collection.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |1       |true (ByPropertyName)|Org    |

#### **PersonalAccessToken**
The Personal Access Token.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |2       |true (ByPropertyName)|PAT    |

#### **UseDefaultCredentials**
If set, will use default credentials when connecting.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Credential**
The credential used to connect.

|Type            |Required|Position|PipelineInput        |
|----------------|--------|--------|---------------------|
|`[PSCredential]`|false   |3       |true (ByPropertyName)|

#### **Server**
The Server.  If this points to a TFS server, it should be the root TFS url, i.e. http://localhost:8080/tfs

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |4       |true (ByPropertyName)|

#### **NoCache**
If set, will not cache teams and projects in order to create argument completers.
If you are using a restricted Personal Access Token, this may prevent errors.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Outputs
* PSDevOps.Connection

---

### Syntax
```PowerShell
Connect-ADO [-Organization] <String> [[-PersonalAccessToken] <String>] [-UseDefaultCredentials] [[-Credential] <PSCredential>] [[-Server] <Uri>] [-NoCache] [<CommonParameters>]
```
