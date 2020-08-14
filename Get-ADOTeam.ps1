function Get-ADOTeam
{
    <#
    .Synopsis
        Gets Azure DevOps Teams
    .Description
        Gets teams from Azure DevOps or TFS
    .Link
        Get-ADOProject
    .Example
        Get-ADOTeam -Organization StartAutomating
    #>
    [CmdletBinding(DefaultParameterSetName='teams')]
    [OutputType('PSDevOps.Team','PSDevOps.TeamMember')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project name or identifier
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}/members',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='graph/descriptors/{teamId}')]
    [string]
    $Project,

    # If set, will return teams in which the current user is a member.
    [Parameter(ParameterSetName='teams',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [Alias('My')]
    [switch]
    $Mine,

    # The Team Identifier
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}/members',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='graph/descriptors/{teamId}')]
    [string]
    $TeamID,

    # If set, will return members of a team.
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams/{teamId}/members')]
    [Alias('Members','Membership')]
    [switch]
    $Member,

    # If set, will return the team identity.
    [Parameter(Mandatory,ParameterSetName='graph/descriptors/{teamId}')]
    [switch]
    $Identity,

    # If set, will list the security groups.
    [Parameter(Mandatory,ParameterSetName='graph/groups')]
    [switch]
    $SecurityGroup,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $psParameterSet = $psCmdlet.ParameterSetName
        $in = $_
        if ($in.Project -and $psParameterSet -notlike '*Project*') {
            $psParameterSet = 'projects/{Project}/teams'
            $project = $psBoundParameters['Project']  = $in.Project
        }
        if ($in.TeamID -and $psParameterSet -notlike '*TeamID*') {
            $psParameterSet = 'projects/{Project}/teams/{teamId}'
        }
        if ($in.TeamID -and -not $TeamID) {
            $TeamID = $in.TeamID
        }

        if ($Identity) {
            $psParameterSet = $($MyInvocation.MyCommand.Parameters['Identity'].Attributes.ParameterSetName)
        }

        if ($psParameterSet -like 'graph*') {
            $server = 'https://vssps.dev.azure.com/'
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
            if ($Server -notlike 'https://*.azure.com/' -and
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
        $typename = @($psParameterSet -split '/' -notlike '{*}')[-1].TrimEnd('s') -replace 'Member', 'TeamMember' # We just need to drop the 's'

        $typeNames = @(
            "$organization.$typename"
            if ($Project) { "$organization.$Project.$typename" }
            "PSDevOps.$typename"
        )
        $invokeParams.Uri = $uri
        $invokeParams.PSTypeName = $typeNames
        $invokeParams.Property = @{Organization=$Organization;Server=$Server}
        if ($Project) { $invokeParams.Property.Project = $Project }
        if ($Identity) {
            $null = $invokeParams.Property.Remove('Server')
            $invokeParams.Property.Team =
                if ($name) { $name }
                elseif ($in.Name)
                { $in.name }

            $invokeParams.Property.TeamID = $TeamID
            $invokeParams.PSTypeName = @(
                "$Organization.TeamDescriptor"
                "$Organization.descriptor"
                if ($Project) {
                    "$Organization.$Project.TeamDescriptor"
                    "$Organization.$Project.descriptor"
                }
                'PSDevOps.TeamDescriptor'
                'PSDevOps.descriptor'
            )
        }

        Invoke-ADORestAPI @invokeParams
    }
}
