function Clear-ADODashboard
{
    <#
    .Synopsis
        Clears Azure DevOps Dashboards
    .Description
        Clears Azure DevOps Dashboards, and Clears settings of Widgets on a dashboard.
    .Example
        Get-ADOTeam -Organization MyOrganization -PersonalAccessToken $pat |
            Get-ADODashboard |
            Clear-ADODashboard
    .Link
        Get-ADODashboard
    .Link
        Remove-ADODashboard
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High',DefaultParameterSetName='dashboard/dashboards/{DashboardId}/widgets')]
    [OutputType('PSDevOps.Dashboard','PSDevOps.Widget')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Handled by underlying commands")]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Team.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Team,

    # The DashboardID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetID}')]
    [string]
    $DashboardID,

    # The WidgetID.  If provided, will get details about a given Azure DevOps Widget.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetID}')]
    [string]
    $WidgetID,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview")
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        $q = [Collections.Queue]::new()
    }

    process {
        $q.Enqueue(@{} + $PSBoundParameters)
    }
    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $dq $q # Pop one off the queue and declare all of it's variables.
            $whatIfConfirm = @{} + $DequedInput
            foreach ($k in @($whatIfConfirm.Keys)) {
                if ($k -notin 'WhatIf', 'Confirm') {
                    $whatIfConfirm.Remove($k)
                }
            }
            $DequedInput.Remove('WhatIf')
            $DequedInput.Remove('Confirm')


            $c++
            Write-Progress "Clearing Dashboards" "$server $Organization $Project" -Id $id -PercentComplete ($c * 100/$t)
            #region Clear Dashboard or Widget Date
            if ($DequedInput.DashboardID -and -not $DequedInput.WidgetID) {
                Get-ADODashboard @DequedInput -Widget |
                    Remove-ADODashboard @whatIfConfirm
            } else {
                Get-ADODashboard @DequedInput |
                    Update-ADODashboard -Setting $null @whatIfConfirm
            }
            #endregion Clear Dashboard or Widget Date


        }

        Write-Progress "Clearing Dashboards" "$server $Organization $Project" -Id $id -Completed
    }
}


