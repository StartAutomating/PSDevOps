function Get-ADOAgentPool
{
    <#
    .Synopsis
        Gets Azure DevOps Agent Pools
    .Description
        Gets Agent Pools and their associated queues from Azure DevOps.

        Queues associate a given project with a pool.
        Pools are shared by organization.

        Thus providing a project will return the queues associated with the project,
        and just providing the organization will return all of the common pools.
    .Example
        Get-ADOAgentPool -Organization MyOrganization -PersonalAccessToken $pat
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/pools/get%20agent%20pools?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/queues/get%20agent%20queues?view=azure-devops-rest-5.1
    #>
    [OutputType('PSDevops.Pool')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    param(
    # The Organization
    [Parameter(Mandatory,ParameterSetName='distributedtask/pools',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='distributedtask/queues',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='distributedtask/pools/{PoolId}/agents',ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Pool ID.  When this is provided, will return agents associated with a given pool ID.
    [Parameter(Mandatory,ParameterSetName='distributedtask/pools/{PoolId}/agents',ValueFromPipelineByPropertyName)]
    [string]
    $PoolID,

    # If provided, will return agents of a given name.
    [Parameter(ParameterSetName='distributedtask/pools/{PoolId}/agents',ValueFromPipelineByPropertyName)]
    [string]
    $AgentName,

    # If set, will return the capabilities of each returned agent.
    [Parameter(ParameterSetName='distributedtask/pools/{PoolId}/agents',ValueFromPipelineByPropertyName)]
    [Alias('Capability','Capabilities','Environment')]
    [switch]
    $IncludeCapability,

    # If set, will return the last completed request of each returned agent.
    [Parameter(ParameterSetName='distributedtask/pools/{PoolId}/agents',ValueFromPipelineByPropertyName)]
    [Alias('IncludeLastCompleted','LastCompleted', 'Completed')]
    [switch]
    $IncludeLastCompletedRequest,

    # If set, will return the requests queued for an agent.
    [Parameter(ParameterSetName='distributedtask/pools/{PoolId}/agents',ValueFromPipelineByPropertyName)]
    [Alias('IncludeAssigned', 'IncludeQueue','Queued')]
    [switch]
    $IncludeAssignedRequest,

    # The project name or identifier.  When this is provided, will return queues associated with the project.
    [Parameter(Mandatory,ParameterSetName='distributedtask/queues',ValueFromPipelineByPropertyName)]
    [string]
    $Project,

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
                    if ($Project) {$project} # the Project (if present),
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne '' -join '/'

            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($IncludeCapability) { "includeCapabilities=true" }
                if ($IncludeLastCompletedRequest) { "includeLastCompletedRequest=true" }
                if ($IncludeAssignedRequest) { "includeAssignedRequest=true" }
                if ($AgentName) { "agentName=$AgentName"}
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
            if ($Project) { $additionalProperties['Project']= $Project }

            Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property $additionalProperties
        }

        Write-Progress "Getting $($ParameterSet)" "$server $Organization $Project" -Id $id -Completed
    }
}
