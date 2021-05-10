function Set-ADOTeam
{
    <#
    .Synopsis
        Sets properties of an Azure DevOps team
    .Description
        Sets metadata for an Azure DevOps team.
    .Link
        Get-ADOTeam
    .Example
        Get-ADOTeam -Organization MyOrganization -Project MyProject -Team MyTeam |
            Set-ADOTeam -Setting @{
                Custom = 'Value'
            }
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/work/teamsettings/update
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Nullable],[PSObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings',ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The team.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings',ValueFromPipelineByPropertyName)]
    [string]
    $Team,

    # A dictionary of team settings.  This is directly passed to the REST api.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings',ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Setting = @{},

    # The team working days.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings',ValueFromPipelineByPropertyName)]
    [Alias('WorkingDays','Workdays')]
    [string[]]
    $Workday,

    # The default iteration for the team.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings',ValueFromPipelineByPropertyName)]
    [Alias('IterationID')]
    [string]
    $DefaultIteration,

    # The bug behavior for the team.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings',ValueFromPipelineByPropertyName)]
    [Alias('BugBehaviors','BugBehaviour', 'BugBehaviours')]
    [ValidateSet('AsRequirements','AsTasks','Off')]
    [string]
    $BugBehavior,

    # The default area path used for a team.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings/teamfieldvalues',ValueFromPipelineByPropertyName)]
    [string]
    $DefaultAreaPath,

    # A list of valid area paths used for a team
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings/teamfieldvalues',ValueFromPipelineByPropertyName)]
    [string[]]
    $AreaPath,

    # If set, will allow work items on the team to be assigned to child area paths of any -AreaPath.
    [Parameter(ParameterSetName='/{Organization}/{Project}/{Team}/_apis/work/teamsettings/teamfieldvalues',ValueFromPipelineByPropertyName)]
    [switch]
    $IncludeChildren,

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
        $q.Enqueue(@{psParameterSet=$PSCmdlet.ParameterSetName} + $psBoundParameters)
    }

    end {
        $q.ToArray() |
            Group-Object { $_.PSParameterSet + ':' + $_.Project + ':' + $_.Team }|
            ForEach-Object {
                $group = $_
                if ($group.Name -like '*/teamsettings:*') {
                    $settings = @{}
                    foreach ($g in $group.Group) {
                        if ($BugBehavior) {
                            $settings.bugsBehavior = $BugBehavior
                        }
                        if ($Workday) {
                            $settings.workingDays = $Workday
                        }
                        if ($DefaultIteration) {
                            $setttings.defaultIteration = $DefaultIteration
                        }
                        if ($g.Setting.Count) {
                            foreach ($kv in $g.Setting.GetEnumerator()) {
                                $settings[$kv.Key] = $kv.Value
                            }
                        }
                    }
                    $invokeParams.Method = 'PATCH'
                    $invokeParams.Body = $settings
                }
                elseif ($group.Name -like '*/teamfieldvalues:*') {
                    $fieldValues = @{defaultValue = $DefaultAreaPath;values=@()}
                    foreach ($ap in $AreaPath) {
                        $fieldValues.values += @{value = $ap;includeChildren=[bool]$IncludeChildren}
                    }
                    $invokeParams.Method = 'PATCH'
                    $invokeParams.Body = $fieldValues
                }

                if ($invokeParams.Body) {
                    $uriBase, $null = $group.Name -split ':', 2
                    $uri = @(
                        "$server".TrimEnd('/')  # * The Server
                        . $ReplaceRouteParameter $uriBase
                    ) -join ''

                    $uri += '?'
                    $uri += @(
                        if ($Server -ne 'https://dev.azure.com' -and
                                -not $psBoundParameters['apiVersion']) {
                            $apiVersion = '2.0'
                        }
                        if ($ApiVersion) { # an api-version (if one exists)
                            "api-version=$ApiVersion"
                        }
                    ) -join '&'
                    $invokeParams.Uri = $uri
                    if ($WhatIfPreference) {
                        $invokeParams.Remove('PersonalAccessToken')
                        return $invokeParams
                    }
                    if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri) $($invokeParams.Body | ConvertTo-Json)")) {
                        Invoke-ADORestAPI @invokeParams -Property @{
                            Organization = $Organization
                            Server       = $server
                            ProjectID    = $ProjectID
                        }
                    }
                }
            }
    }
}
