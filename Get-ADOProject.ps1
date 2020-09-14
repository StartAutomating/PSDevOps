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
    .Example
        Get-ADOProject -Organization StartAutomating -Project PSDevOps
    .Example
        Get-ADOProject -Organization StartAutomating -Project PSDevOps |
            Get-ADOProject -Metadata
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/projects')]
    [OutputType('PSDevOps.Project','PSDevOps.Property')]
    param(
    # The project name.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/projects/{Project}')]
    [string]
    $Project,

    # The project identifier.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/projects/{ProjectID}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/work/processconfiguration')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}/deliverytimeframe')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/policy/types')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/policy/configurations')]
    [string]
    $ProjectID,

    # If set, will get project metadta
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties')]
    [Alias('Property','Properties')]
    [switch]
    $Metadata,

    # If set, will return the process configuration of a project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/processconfiguration')]
    [switch]
    $ProcessConfiguration,

    # If set, will return the policy configuration of a project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/policy/configurations')]
    [switch]
    $PolicyConfiguration,

    # If set, will return the policy types available in a given project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/policy/types')]
    [Alias('PolicyTypes')]
    [switch]
    $PolicyType,

    # If set, will return the plans related to a project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans')]
    [switch]
    $Plan,

    # If set, will a specific project plan.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}')]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}/deliverytimeline')]
    [string]
    $PlanID,

    # If set, will return the project delivery timeline associated with a given planID.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}/deliverytimeline')]
    [string]
    $DeliveryTimeline,

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
        $in = $_
        $psParameterSet = $psCmdlet.ParameterSetName
        if ($in.ProjectID -and $psParameterSet -notlike '*{ProjectId}*') {
            $ProjectID = $psBoundParameters['ProjectID'] = $in.ProjectID
            $psParameterSet = '/{Organization}/_apis/projects/{ProjectID}'
        }
        $uri =
            "$(@(
                "$server".TrimEnd('/')  # * The Server
                . $ReplaceRouteParameter $psParameterSet #* and the replaced route parameters.
            )  -join '')?$( # Followed by a query string, containing
            @(
                if ($Server -ne 'https://dev.azure.com' -and
                        -not $psBoundParameters['apiVersion']) {
                    $apiVersion = '2.0'
                }
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"

        $typeName = @($psCmdlet.ParameterSetName -split '/' -notlike '{*}')[-1] -replace
            '\{' -replace '\}' -replace 'ies$', 'y' -replace 's$' -replace 'ID$' -replace
            'type', 'PolicyType' -replace 'configuration', 'PolicyConfiguration'


        $additionalProperty = @{
            Organization = $Organization
            Server = $Server
        }
        if ($ProjectID) { $additionalProperty.ProjectID = $ProjectID }
        Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.$typeName",
            "PSDevOps.$typeName" -Property $additionalProperty
    }
}