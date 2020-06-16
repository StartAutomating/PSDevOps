function Get-ADOServiceEndpoint
{
    <#
    .Synopsis
        Gets Azure DevOps Service Endpoints
    .Description
        Gets Service Endpoints from Azure DevOps.

        Service Endpoints are used to connect an Azure DevOps project to one or more web services.

        To see the types of service endpoints, use Get-ADOServiceEndpoint -GetEndpointType
    .Example
        Get-ADOServiceEndpoint -Organization MyOrg -Project MyProject -PersonalAccessToken $myPersonalAccessToken
    .Example
        Get-ADOServiceEndpoint -Organization MyOrg -GetEndpointType -PersonalAccessToken $myPersonalAccessToken
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/get%20service%20endpoints?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/serviceendpoint/endpoints/get?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='serviceendpoint/endpoints')]
    [OutputType('PSDevOps.ServiceEndpoint', 'StartAutomating.PSDevOps.ServiceEndpoint.History', 'StartAutomating.PSDevOps.ServiceEndpoint.Type')]
    param(
    # The Organization
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/endpoints',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/endpoints/{EndpointId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/{EndpointId}/executionhistory',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/types',ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/endpoints',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/endpoints/{EndpointId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/{EndpointId}/executionhistory',ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Endpoint ID
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/endpoints/{EndpointId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/{EndpointId}/executionhistory',ValueFromPipelineByPropertyName)]
    [string]
    $EndpointID,

    # If set, will get the execution history of the endpoint.
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/{EndpointId}/executionhistory',ValueFromPipelineByPropertyName)]
    [Alias('ExecutionHistory')]
    [switch]
    $History,

    # If set, will get the types of endpoints.
    [Parameter(Mandatory,ParameterSetName='serviceendpoint/types',ValueFromPipelineByPropertyName)]
    [Alias('GetEndpointTypes')]
    [switch]
    $GetEndpointType,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
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
        $uri += '?'
        $uri += $(@(
            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($ApiVersion) { # an api-version (if one exists)
                "api-version=$ApiVersion"
            }
        ) -join '&')


        $subTypeName =
            if ($History) {
                '.History'
            } elseif ($GetEndpointType) {
                '.Type'
            } else {
                ''
            }
        Invoke-ADORestAPI @invokeParams -Uri $uri -PSTypeName @( # Prepare a list of typenames so we can customize formatting:
            "$Organization.$Project.ServiceEndpoint$subTypeName" # * $Organization.$Project.ServiceEndpoint
            "$Organization.ServiceEndpoint$subTypeName" # * $Organization.ServiceEndpoint
            "PSDevOps.ServiceEndpoint$subTypeName" # * StartAutomating.PSDevOps.ServiceEndpoint
        ) -Property @{
            Organization = $Organization
            Project = $Project
            Server = $Server
        }
    }
}