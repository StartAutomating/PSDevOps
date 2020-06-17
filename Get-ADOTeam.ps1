function Get-ADOTeam
{
    <#
    .Synopsis
        Gets Azure DevOps Teams
    .Description
        Gets teams from Azure DevOps or TFS
    .Example
        Get-ADOTeam -Organization StartAutomating
    #>
    [CmdletBinding(DefaultParameterSetName='teams')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,
    
    # The project name or identifier
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}/members',ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    [Parameter(ParameterSetName='teams',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [Alias('My')]
    [switch]
    $Mine,

    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}/members',ValueFromPipelineByPropertyName)]
    [string]
    $TeamID,

    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}/members')]
    [Alias('Members','Membership')]
    [switch]
    $Member,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $authParams = @{} + $invokeParams
    }

    process {
        $psParameterSet = $psCmdlet.ParameterSetName
        $in = $_
        if ($in.Project -and $psParameterSet -notlike '*Project*') {
            $psParameterSet = 'projects/{Project}/teams'
            $project = $psBoundParameters['Project']  = $in.Project
        }

        $uri = # The URI is comprised of:
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                $Organization            # the Organization,
                '_apis'                  # the API Root ('_apis'),
                (. $ReplaceRouteParameter $psParameterSet)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'

        $uri += '?' # The URI has a query string containing:
        $uri += @(
            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($Mine) {
                '$mine=true'
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
