Get-ADOServiceHook
------------------

### Synopsis
Gets Azure DevOps Service Hooks

---

### Description

Gets Azure DevOps Service Hook Subscriptions, Consumers, and Publishers.

A subscription maps a publisher of events to a consumer of events.

---

### Related Links
* [https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/subscriptions/list?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/subscriptions/list?view=azure-devops-rest-5.1)

* [https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/consumers/list?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/consumers/list?view=azure-devops-rest-5.1)

* [https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/consumers/list%20consumer%20actions?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/consumers/list%20consumer%20actions?view=azure-devops-rest-5.1)

* [https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/publishers/list?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/publishers/list?view=azure-devops-rest-5.1)

* [https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/publishers/list%20event%20types?view=azure-devops-rest-5.1](https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/publishers/list%20event%20types?view=azure-devops-rest-5.1)

---

### Examples
Gets subscriptions.  If none exist, nothing is returned.

```PowerShell
Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat
```
Gets potential consumers

```PowerShell
Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Consumer
```
Gets the actions of all consumers

```PowerShell
Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Consumer |
    Get-ADOServiceHook -Action
```
Gets potential publishers

```PowerShell
Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Publisher
```
Gets the event types of all publishers

```PowerShell
Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Publisher|
    Get-ADOServiceHook -EventType
```

---

### Parameters
#### **Organization**
The Organization

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |named   |true (ByPropertyName)|Org    |

#### **Consumer**
If set, will list consumers.  Consumers can receive events from a publisher.

|Type      |Required|Position|PipelineInput        |Aliases  |
|----------|--------|--------|---------------------|---------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Consumers|

#### **ConsumerID**
The Consumer ID.  This can be provided to get details of an event consumer, or to list actions related to the event consumer.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **Action**
If set, will list actions available in a given event consumer.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Actions|

#### **Publisher**
If set, will list publishers.  Publishers can provide events to a consumer.

|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[Switch]`|true    |named   |true (ByPropertyName)|Publishers|

#### **PublisherID**
The Publisher ID.  This can be provided to get details of an event publisher, or to list actions related to the event publisher.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|

#### **EventType**
If set, will list event types available from a given event publisher.

|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[Switch]`|true    |named   |true (ByPropertyName)|EventTypes|

#### **Server**
The server.  By default https://dev.azure.com/.
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

---

### Outputs
* PSDevops.Subscription

* PSDevops.Consumer

* PSDevops.Publisher

* PSDevops.EventType

* PSDevops.Action

---

### Syntax
```PowerShell
Get-ADOServiceHook -Organization <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceHook -Organization <String> -Consumer [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceHook -Organization <String> -ConsumerID <String> -Action [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceHook -Organization <String> -ConsumerID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceHook -Organization <String> -Publisher [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceHook -Organization <String> -PublisherID <String> -EventType [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
```PowerShell
Get-ADOServiceHook -Organization <String> -PublisherID <String> [-Server <Uri>] [-ApiVersion <String>] [<CommonParameters>]
```
