function Get-ADOProject
{
    <#
    .Synopsis
        Gets projects from Azure DevOps.
    .Description
        Gets projects from Azure DevOps or TFS.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/list?view=azure-devops-rest-5.1
    .Example
        Get-ADOProject -Organization StartAutomating -PersonalAccessToken $pat
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/projects')]
    param(
    # The project name or identifier.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/projects/{Project}',ValueFromPipelineByPropertyName)]
    [Alias('ProjectID')]
    [string]
    $Project,

    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 2.0.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "2.0"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }
    process {
        $uri =
            "$(@(
                "$server".TrimEnd('/') # * The Server
                . $ReplaceRouteParameter $psCmdlet.ParameterSetName #* and the replaced route parameters.
            )  -join '/')?$( # Followed by a query string, containing
            @(
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"

        Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.Project", "PSDevOps.Project" -Property @{
            Organization = $Organization
            Server = $Server
        }
    }
}