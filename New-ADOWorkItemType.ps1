function New-ADOWorkItemType
{
    <#
    .Synopsis
        Creates custom work item types
    .Description
        Creates custom work item types in Azure DevOps.

        Also creates custom rules or states for a work item type.
    .Example
        Get-ADOProject -Organization StartAutomating -Project PSDevOps |
            Get-ADOWorkProcess |
                New-ADOWorkItemType -Name ServiceRequest -Color 'ddee00' -Icon icon_flame
    .Link
        Get-ADOWorkItemType
    .Link
        Remove-ADOWorkItemType
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes',
        SupportsShouldProcess,ConfirmImpact='Medium')]
    [OutputType('PSDevOps.WorkItemType','PSDevOps.Rule', 'PSDevOps.State', 'PSDevOps.Behavior')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The process identifier.  This can be piped in from Get-ADOWorkProcess.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors')]
    [Alias('TypeID')]
    [string]
    $ProcessID,

    # The name of the custom work item type, custom work item type state, custom work item type rule, or custom work item type behavior.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName, Position = 0,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors')]
    [string]
    $Name,

    # The name of the icon used for the custom work item.
    # To list available icons, use Get-ADOWorkItemType -Icon
    [Parameter(ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes',ValueFromPipelineByPropertyName)]
    [string]
    $Icon,

    # The color of the work item type or state.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors')]
    [string]
    $Color,

    # The description for the custom work item type.
    [Parameter(ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes',ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # The work item type the custom work item should inherit, or the backlog behavior that should be inherited.
    [Parameter(ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes',
        ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors')]
    [Alias('Inherits')]
    [string]
    $InheritsFrom,

    # If set, will create the work item type disabled.
    [Parameter(ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes',ValueFromPipelineByPropertyName)]
    [Alias('Disabled')]
    [switch]
    $IsDisabled,

    # If set, will associate a given work item type with a behavior (for instance, adding a type of work item to be displayed in a backlog)
    [Parameter(ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors',ValueFromPipelineByPropertyName)]
    [string]
    $BehaviorID,

    # If set, will make the given work item type the default within a particular behavior (for instance, making the work item type the default type of a backlog).
    [Parameter(ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors',ValueFromPipelineByPropertyName)]
    [switch]
    $IsDefault,

    # If set, will create a new state for a custom work item instead of a custom work item.
    [Parameter(Mandatory,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors')]
    [switch]
    $Behavior,

    # The Reference Name of a WorkItemType.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{organization}/_apis/work/processes/{processId}/workitemtypesbehaviors/{ReferenceName}/behaviors')]
    [string]
    $ReferenceName,

    # If set, will create a new state for a custom work item instead of a custom work item.
    [Parameter(Mandatory,
        ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [switch]
    $State,

    # The order of the a custom state for a custom work item.
    [Parameter(ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [int]
    $Order,

    # The state category of a custom state for a custom work item.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workitemtypes/{ReferenceName}/states')]
    [ValidateSet('Proposed','InProgress','Resolved','Completed', 'Removed')]
    [string]
    $StateCategory,

    # The type of work item rule to create.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [ValidateSet('when','whenChanged','whenNot', 'whenNotChanged',
        'whenStateChangedFromAndTo','whenStateChangedTo','whenValueIsDefined',
        'whenValueIsNotDefined','whenWas', 'whenWorkItemIsCreated')]
    [Alias('Condition')]
    [string[]]
    $RuleConditionType,

    # The field for a given rule condition.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [Alias('Key')]
    [string[]]
    $Field,

    # The value of a given rule condition.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [string[]]
    $Value,

    # The type of action run when the work item rule is triggered.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [ValidateSet('copyFromClock','copyFromCurrentUser','copyFromField',
        'copyFromServerClock','copyFromServerCurrentUser','copyValue',
        'makeReadOnly','makeRequired','setDefaultFromClock',
        'setDefaultFromCurrentUser','setDefaultFromField',
        'setDefaultValue','setValueToEmpty')]
    [string[]]
    $RuleActionType,

    # The target field for a given rule action.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [string[]]
    $TargetField,

    # The target value for a given rule action.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/work/processes/{processId}/workitemtypes/{ReferenceName}/rules')]
    [string[]]
    $TargetValue,

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
        $psParameterSet = $psCmdlet.ParameterSetName
        $in = $_
        if (-not $ProcessID -and $in.ProcessID) {
            $ProcessID = $in.ProcessID
        }

        $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $psParameterSet) + '?'
        if ($ApiVersion) {
            $uri += "api-version=$ApiVersion"
        }

        $typeName = @($psParameterSet -split '/')[-1].TrimEnd('s') -replace
            'processe$', 'WorkProcess' -replace
            '\{ProcessId\}', 'WorkProcess'

        $invokeParams.Method = 'POST'
        $body = @{}
        foreach ($k in 'name','color','description','icon','inheritsFrom','isDisabled', 'order', 'stateCategory') {
            $body[$k] = $ExecutionContext.SessionState.PSVariable.Get($k).Value
            if ([string]::IsNullOrEmpty($body[$k])) { $body.Remove($k) }
            if ($body[$k] -is [switch]) {
                $body[$k] = ($body[$k].IsPresent -as [bool])
            }
        }

        if ($psParameterSet -like '*{ProcessId}/behaviors') {
            $body.inherits = $body.inheritsfrom
            $body.Remove('inheritsFrom')
        }

        if ($typeName -eq 'state' -or $typeName -eq 'behavior') {
            $body.Remove('IsDisabled')
        }
        if ($RuleConditionType) {
            $i = 0
            $body.conditions =
                @(foreach ($rc in $RuleConditionType) {
                    $newRuleCondition = @{conditionType="$rc"}
                    if ($field -and -not [String]::IsNullOrEmpty($Field[$i])) {
                        $newRuleCondition.field = $field[$i]
                    }
                    if ($value -and -not [String]::IsNullOrEmpty($Value[$i])) {
                        $newRulecondition.value = $value[$i]
                    }
                    $newRuleCondition
                    $i++
                })
        }

        if ($RuleActionType) {
            $i = 0
            $body.actions =
                @(foreach ($ra in $RuleActionType) {
                    $newRuleAction = @{actionType="$ra"}
                    if ($TargetField -and -not [String]::IsNullOrEmpty($targetField[$i])) {
                        $newRuleAction.targetField = $targetField[$i]
                    }
                    if ($TargetValue -and -not [String]::IsNullOrEmpty($TargetValue[$i])) {
                        $newRuleAction.value = $TargetValue[$i]
                    }
                    $newRuleAction
                    $i++
                })
        }

        if ($psParameterSet -like '*{ReferenceName}/behaviors') {
            $body = @{}
            $body.behavior = @{id=$BehaviorID}
            $body.isDefault = ($IsDefault -as [bool])
        }

        $invokeParams.Body = $body
        $invokeParams.Uri = $uri
        if ($WhatIfPreference){
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }

        if ($psCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            Invoke-ADORestAPI @invokeParams -PSTypeName "$Organization.$typeName", "PSDevOps.$typeName" -Property @{
                Organization = $Organization
                Server = $Server
            }
        }
    }
}