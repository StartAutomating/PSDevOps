function Get-ADOProject
{
    <#
    .Synopsis
        Gets projects from Azure DevOps.
    .Description
        Gets projects from Azure DevOps or TFS.
    .Example
        Get-ADOProject -Organization StartAutomating -PersonalAccessToken $pat
    .Example
        Get-ADOProject -Organization StartAutomating -Project PSDevOps
    .Example
        Get-ADOProject -Organization StartAutomating -Project PSDevOps |
            Get-ADOProject -Metadata
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/core/projects/list
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/list
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
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/wiki/wikis')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/test/runs')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/testplan/plans')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/release/releases')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/{ProjectID}/_apis/release/approvals')]
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

    # If set, will return the test runs associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/test/runs')]
    [Alias('TestRuns')]
    [switch]
    $TestRun,

    # If set, will return the test plans associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/testplan/plans')]
    [Alias('TestPlans')]
    [switch]
    $TestPlan,

    # If set, will a specific project plan.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}')]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}/deliverytimeline')]
    [string]
    $PlanID,

    # If set, will return the project delivery timeline associated with a given planID.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/work/plans/{PlanID}/deliverytimeline')]
    [string]
    $DeliveryTimeline,

    # If set, will return any wikis associated with the project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/wiki/wikis')]
    [switch]
    $Wiki,

    # If set, will return releases associated with the project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/release/releases')]
    [Alias('Releases')]
    [switch]
    $Release,

    # If set, will return pending approvals associated with the project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{ProjectID}/_apis/release/approvals')]
    [Alias('PendingApprovals')]
    [switch]
    $PendingApproval,

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

        $q = [Collections.Queue]::new()
    }
    process {
        $in = $_
        $psParameterSet = $psCmdlet.ParameterSetName
        if ($in.ProjectID -and $psParameterSet -notlike '*{ProjectId}*') {
            $ProjectID = $psBoundParameters['ProjectID'] = $in.ProjectID
            $psParameterSet = '/{Organization}/_apis/projects/{ProjectID}'
        }
        $q.Enqueue(@{PSParameterSet=$psParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $dq $q

            if (($Release -or $PendingApproval) -and ($Server -eq 'https://dev.azure.com')) {
                $Server = "https://vsrm.dev.azure.com"
            }

            $uri =
                "$(@(
                    "$server".TrimEnd('/')  # * The Server
                    . $ReplaceRouteParameter $psParameterSet #* and the replaced route parameters.
                )  -join '')?$( # Followed by a query string, containing
                @(
                    if ($Server -notlike 'https://*dev.azure.com/' -and
                            -not $psBoundParameters['apiVersion']) {
                        $apiVersion = '2.0'
                    }
                    if ($ApiVersion) { # an api-version (if one exists)
                        "api-version=$ApiVersion"
                    }
                ) -join '&'
                )"
            $c++
            Write-Progress "Getting" " [$c/$t] $uri" -PercentComplete ($c * 100 / $t) -Id $progId

            $typeName = @($psParameterSet -split '/' -notlike '{*}')[-1] -replace
                '\{' -replace '\}' -replace 'ies$', 'y' -replace 's$' -replace 'ID$' -replace
                'type', 'PolicyType' -replace 'configuration', 'PolicyConfiguration' -replace 'Run', 'TestRun'

            if ($typeName -eq 'plan' -and $psParameterSet -like '*testplan*') {
                $typeName = 'TestPlan'
            }


            $additionalProperty = @{
                Organization = $Organization
                Server = $Server
            }
            if ($ProjectID) { $additionalProperty.ProjectID = $ProjectID }
            Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.$typeName",
                "PSDevOps.$typeName" -Property $additionalProperty
        }

        Write-Progress "Getting" "[$c/$t]" -Completed -Id $progId
    }
}