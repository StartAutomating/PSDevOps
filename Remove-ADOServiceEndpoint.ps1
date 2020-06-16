function Remove-ADOServiceEndpoint
{
    <#
    .Synopsis
        Removes Azure DevOps Service Endpoints
    .Description
        Removes Azure DevOps Service Endpoints.
        Service Endpoints allow you to connect an Azure DevOps project with to one or more web services.
    .Example
        # clears the service endpoints for MyOrg/MyProject.  -PersonalAccessToken must be provided
        Get-ADOServiceEndpoint -Organization MyOrg -Project MyProject | Remove-ADOServiceEndpoint
    .Link
        Get-ADOServiceEndpoint
    .Link
        New-ADOServiceEndpoint
    #>
    [CmdletBinding(DefaultParameterSetName='serviceendpoint/endpoints/{EndpointId}',SupportsShouldProcess,ConfirmImpact='High')]
    [OutputType([Nullable], [PSObject])]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Endpoint ID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $EndpointID,

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
                "$server".TrimEnd('/') # the Server (minus any trailing slashes),
                $Organization          # the Organization,
                $Project               # the Project,
                '_apis'                # the API Root ('_apis'),
                (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName)
                                       # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'
        $uri += '?' # The URI has a query string containing:
        $uri += @(
            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($ApiVersion) { # * The api-version
                "api-version=$ApiVersion"
            }
        ) -join '&'

        $invokeParams += @{Method='DELETE';Uri=$uri} # we are DELETEing that URI.

        if ($WhatIfPreference) { # If -WhatIf was passed,
            $invokeParams.Remove('PersonalAccessToken') # remove the personal access token
            return $invokeParams # and return the invoke parameters
        }

        # If we do not confirm the ShouldProcess, return.
        if (-not $psCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {return }
        Invoke-ADORestAPI @invokeParams # Otherwise, DELETE the URI
    }
}