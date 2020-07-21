function Get-ADOServiceHook
{
    <#
    .Synopsis
        Gets Azure DevOps Service Hooks
    .Description
        Gets Azure DevOps Service Hook Subscriptions, Consumers, and Publishers.

        A subscription maps a publisher of events to a consumer of events.         
    .Example
        # Gets subscriptions.  If none exist, nothing is returned.
        Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/subscriptions/list?view=azure-devops-rest-5.1
    .Example
        # Gets potential consumers
        Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Consumer
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/consumers/list?view=azure-devops-rest-5.1
    .Example
        # Gets the actions of all consumers
        Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Consumer | 
            Get-ADOServiceHook -Action
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/consumers/list%20consumer%20actions?view=azure-devops-rest-5.1   
    .Example
        # Gets potential publishers
        Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Publisher
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/publishers/list?view=azure-devops-rest-5.1
    .Example
        # Gets the event types of all publishers
        Get-ADOServiceHook -Organization MyOrganization -PersonalAccessToken $pat -Publisher|
            Get-ADOServiceHook -EventType
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/hooks/publishers/list%20event%20types?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='hooks/subscriptions')]
    [OutputType('PSDevops.Subscription','PSDevops.Consumer','PSDevops.Publisher','PSDevops.EventType','PSDevops.Action')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # If set, will list consumers.  Consumers can receive events from a publisher. 
    [Parameter(Mandatory,ParameterSetName='hooks/consumers',ValueFromPipelineByPropertyName)]
    [Alias('Consumers')]
    [switch]
    $Consumer,

    # The Consumer ID.  This can be provided to get details of an event consumer, or to list actions related to the event consumer.
    [Parameter(Mandatory,ParameterSetName='hooks/consumers/{ConsumerId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='hooks/consumers/{ConsumerId}/actions',ValueFromPipelineByPropertyName)]
    [string]
    $ConsumerID,

    # If set, will list actions available in a given event consumer.
    [Parameter(Mandatory,ParameterSetName='hooks/consumers/{ConsumerId}/actions',ValueFromPipelineByPropertyName)]
    [Alias('Actions')]
    [switch]
    $Action,

    # If set, will list publishers.  Publishers can provide events to a consumer.
    [Parameter(Mandatory,ParameterSetName='hooks/publishers',ValueFromPipelineByPropertyName)]
    [Alias('Publishers')]
    [switch]
    $Publisher,

    # The Publisher ID.  This can be provided to get details of an event publisher, or to list actions related to the event publisher.
    [Parameter(Mandatory,ParameterSetName='hooks/publishers/{PublisherId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='hooks/publishers/{PublisherId}/eventTypes',ValueFromPipelineByPropertyName)]
    [string]
    $PublisherID,

    # If set, will list event types available from a given event publisher.
    [Parameter(Mandatory,ParameterSetName='hooks/publishers/{PublisherId}/eventTypes',ValueFromPipelineByPropertyName)]
    [Alias('EventTypes')]
    [switch]
    $EventType,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview")
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q = [Collections.Queue]::new()
    }

    process {
        $ParameterSet = $psCmdlet.ParameterSetName
        $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).
            if ($t -gt 1) {
                $c++
                Write-Progress "Getting $(@($ParameterSet -split '/')[-1])" "$server $Organization $Project" -Id $id -PercentComplete ($c * 100/$t)
            }
            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -join '/'

            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'

            # We want to decorate our return value.  Handily enough, both URIs contain a distinct name in the last URL segment.
            $typename = @($psCmdlet.ParameterSetName -split '/')[-1].TrimEnd('s') # We just need to drop the 's'
            $typeNames = @(
                "$organization.$typename"
                if ($Project) { "$organization.$Project.$typename" }
                "PSDevOps.$typename"
            )

            $additionalProperties = @{Organization=$Organization;Server=$Server}
            if ($Consumer) {
                $invokeParams.DecorateProperty = @{Actions = "$Organization.Action", 'PSDevOps.Action'}
            }
            if ($Publisher) {
                $invokeParams.DecorateProperty = @{SupportedEvents = "$Organization.EventType", 'PSDevOps.EventType'}  
            }
            if ($ConsumerID)  { $additionalProperties['ConsumerID']  = $ConsumerID  }
            if ($PublisherID) { $additionalProperties['PublisherID'] = $PublisherID }

            Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property $additionalProperties
        }

        Write-Progress "Getting $($ParameterSet)" "$server $Organization $Project" -Id $id -Completed
    }
}
