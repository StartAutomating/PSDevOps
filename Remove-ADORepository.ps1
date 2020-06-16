function Remove-ADORepository
{
    <#
    .Synopsis
        Removes an Azure DevOps Repository
    .Description
        Removes repositories from Azure DevOps.
    #>
    [CmdletBinding(DefaultParameterSetName='git/repositories/{RepositoryId}',SupportsShouldProcess,ConfirmImpact='High')]
    [OutputType([Nullable],[Hashtable])]
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

    # The name or ID of the repository
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryID,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1")
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $realRepositoryId = if ($Repositoryid -as [guid]) {
            $RepositoryID
        } else {
            Get-ADORepository -Organization $Organization -Project $Project -RepositoryID $repositoryId @invokeParams |
                Select-Object -ExpandProperty ID
        }

        $RepositoryID = $realRepositoryId

        $uri =
            "$(@(
                "$server".TrimEnd('/') # * The Server
                $Organization # * The Organization
                $Project # * The Project
                '_apis' #* '_apis'
                . $ReplaceRouteParameter $psCmdlet.ParameterSetName #* and the replaced route parameters.
            )  -join '/')?$( # Followed by a query string, containing
            @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"



        $invokeParams += @{Uri = $uri;Method = 'DELETE'}


        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }

        if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            Invoke-ADORestAPI @invokeParams
        }
    }
}
