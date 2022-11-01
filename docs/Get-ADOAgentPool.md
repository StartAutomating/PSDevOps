Get-ADOAgentPool
----------------
### Synopsis
Gets Azure DevOps Agent Pools

---
### Description

Gets Agent Pools and their associated queues from Azure DevOps.

Queues associate a given project with a pool.
Pools are shared by organization.

Thus providing a project will return the queues associated with the project,
and just providing the organization will return all of the common pools.

---
### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/pools/get%20agent%20pools](https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/pools/get%20agent%20pools)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/queues/get%20agent%20queues](https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/queues/get%20agent%20queues)



* [https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/agents/list](https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/agents/list)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ADOAgentPool -Organization MyOrganization -PersonalAccessToken $pat
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
#### **PoolID**

The Pool ID.  When this is provided, will return agents associated with a given pool ID.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AgentName**

If provided, will return agents of a given name.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeCapability**

If set, will return the capabilities of each returned agent.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeLastCompletedRequest**

If set, will return the last completed request of each returned agent.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IncludeAssignedRequest**

If set, will return the requests queued for an agent.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Project**

The project name or identifier.  When this is provided, will return queues associated with the project.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



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
* PSDevops.Pool




---
### Syntax
```PowerShell
Get-ADOAgentPool -Organization <String> -PoolID <String> [-AgentName <String>] [-IncludeCapability] [-IncludeLastCompletedRequest] [-IncludeAssignedRequest] [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOAgentPool -Organization <String> -Project <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOAgentPool -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
---
