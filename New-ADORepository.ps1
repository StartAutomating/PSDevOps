function New-ADORepository
{
    <#
    .Synopsis
        Creates repositories in Azure DevOps
    .Description
        Creates a new repository in Azure DevOps.
    #>
    [CmdletBinding(DefaultParameterSetName='git/repositories',SupportsShouldProcess)]
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

    # The name of the repository
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryName,

    # The name of the upstream repository (this creates a forked repository from the same project)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ForkName')]
    [string]
    $UpstreamName,

    # The ID of an upstream repository (this creates a forked repository)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ForkID')]
    [string]
    $UpstreamID,

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

        $projectID = Get-ADOProject @invokeParams -Organization $Organization -Project $Project |
            Select-Object -ExpandProperty ID
        if (-not $projectId) { return } 

        $body = @{
            name = $RepositoryName
            project = @{id=$projectID}
        }


        if ($UpstreamName) {
            $body.parentRepository = @{Name=$UpstreamName;Project=@{name=$Project}}
        } elseif ($UpstreamID) {
            $body.parentRepository = @{ID=$UpstreamID}
        }
        $invokeParams += @{Uri = $uri;Method = 'POST';Body=$body}
        

        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }

        if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            Invoke-ADORestAPI @invokeParams -PSTypeName @(
                "$Organization.$Project.Repository",
                "$Organization.Repository",
                "PSDevOps.Repository"
            ) -Property @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
        }
    }
}