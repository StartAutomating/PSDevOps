function Remove-ADOWorkItemType
{
    <#
    .Synopsis
        Removes custom work item types.
    .Description
        Removes custom work item types from Azure DevOps.

        Also removes custom work item type states, rules, and behaviors.
    .Example
        Get-ADOProject -Organization $myOrganization -Project $myProject -PersonalAccessToken $myPat |
            Get-ADOWorkProcess |
            Remove-ADOWorkItemType -WorkItemTypeName ServiceRequest
    .Link
        Get-ADOWorkItemType
    .Link
        New-ADOWorkItemType
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High',
        DefaultParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{WorkItemTypeName}')]
    [OutputType([Nullable])]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Process identifier.  This work process must contain the custom work item type.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{WorkItemTypeName}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{WorkItemTypeName}/states/{StateId}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{WorkItemTypeName}/rules/{RuleID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors/{BehaviorID}')]
    [Alias('TypeID')]
    [string]
    $ProcessID,

    # The name of the custom work item type.  Values with a property 'ReferenceName' will be accepted.
    [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
    [Alias('ReferenceName')]
    [string]
    $WorkItemTypeName,

    # The id of a custom work item state that will be removed.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{WorkItemTypeName}/states/{StateId}')]
    [string]
    $StateID,

    # The id of a custom work item rule that will be removed.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{WorkItemTypeName}/rules/{RuleID}')]
    [string]
    $RuleID,

    # The id of a custom work item behavior that will be removed.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors/{BehaviorID}')]
    [string]
    $BehaviorID,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
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
        if ($WorkItemTypeName -notlike '*.*' -and
            $in.ProcessId -and $in.Name) {
            $WorkItemTypeName = $($in.Name -replace '\W') + '.' + $WorkItemTypeName
        }

        $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $psParameterSet) + '?'
        if ($Server -ne 'https://dev.azure.com/' -and
            -not $PSBoundParameters['apiVersion']) {

        }
        if ($ApiVersion) {
            $uri += "api-version=$ApiVersion"
        }

        $invokeParams.Method = 'DELETE'
        $invokeParams.Uri    = $uri

        if ($WhatIfPreference) { # If -WhatIf was passed,
            $invokeParams.Remove('PersonalAccessToken') # remove any PersonalAccessToken from invokeparams
            return $invokeParams # and return what would be invoked.
        }

        if (-not $psCmdlet.ShouldProcess("DELETE $uri")) { # If we don't want to delete the endpoint
            return
        }

        Invoke-ADORestAPI @invokeParams
    }
}
