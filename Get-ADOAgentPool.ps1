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
    [CmdletBinding(DefaultParameterSetName='distributedtask/pools')]
    [OutputType('PSDevops.Pool')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project name or identifier.
    [Parameter(Mandatory,ParameterSetName='distributedtask/queues',ValueFromPipelineByPropertyName)]
    [Alias('ProjectID')]
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
    }

    process {
        $uri = # The URI is comprised of:  
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                $Organization            # the Organization,
                if ($Project) {$project} # the Project (if present),
                '_apis'                  # the API Root ('_apis'),
                (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'
        
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

        Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property @{
            Organization = $Organization
            Project = $Project
            Server = $Server
        }
    }
}
