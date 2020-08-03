function New-ADODashboard {
    <#
    .Synopsis
        Creates Dashboards and Widgets
    .Description
        Creates Dashboards from Azure DevOps, or Creates Widgets in a Dashboard in Azure Devops.
    .Example
        New-ADODashboard -Organization MyOrg -Project MyProject -Team MyTeam -Name MyDashboard
    .Example
        Get-ADODashboard -Organization MyOrg -Project MyProject -Team MyTeam |
            Select-Object -First 1 |
            New-ADODashboard -Name BuildHistory -ContributionID ms.vss-dashboards-web.Microsoft.VisualStudioOnline.Dashboards.BuildHistogramWidget -ColumnSpan 2
    .Link
        Get-ADODashboard
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('PSDevOps.Dashboard', 'PSDevOps.Widget')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired")]
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

    # The name of the dashboard or widget.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # A description of the dashboard
    [Parameter(ParameterSetName='dashboard/dashboards', ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # Widgets created with the dashboard.
    [Parameter(ParameterSetName='dashboard/dashboards', ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $Widget,

    # The DashboardID. This dashboard will contain the new widgets.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [string]
    $DashboardID,

    # The ContributionID.  This describes the exact extension contribution the widget will use.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [string]
    $ContributionID,

    # The row of the widget.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [int]
    $Row,

    # The column of the widget.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [int]
    $Column,

    # The number of rows the widget should occupy.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [int]
    $RowSpan = 1,

    # The number of columns the widget should occupy.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [int]
    $ColumnSpan = 1,

    # The widget settings.  Settings are specific to each widget.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='dashboard/dashboards/{DashboardId}/widgets/{WidgetId}')]
    [Alias('Settings')]
    [PSObject]
    $Setting,

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
        $ParameterSet = $psCmdlet.ParameterSetName
        $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).

            $c++
            Write-Progress "Removing $(@($ParameterSet -split '/')[-1])" "$Organization $Project $Team" -Id $id -PercentComplete ($c * 100/$t)

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    $Project
                    if ($Team) { $team }
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne ''  -join '/'

            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'

            $invokeParams.Uri = $uri
            $invokeParams.Method  = 'POST'
            $additionalProperty = @{Organization=$Organization;Project=$Project}
            if ($Team) { $additionalProperty += @{Team=$team} }
            $invokeParams.Property = $additionalProperty
            $body = @{
                name = $Name
            }

            if (-not $DashboardID) { # If we're not passing a DashboardID, we're creating dashboards.
                $invokeParams.PSTypeName = "$Organization.Dashboard", "$Organization.$project.Dashboard", 'PSDevOps.Dashboard'
                $body += @{
                    description = $Description
                }
                if ($Widget) {
                    $body.widgets= $Widget
                }
            } else {
                $additionalProperty.DashboardID = $DashboardID
                $body += @{
                    contributionID = $ContributionID
                }
                if ($row -and $column) {
                    $body.position = @{row=$row;column=$Column}
                }
                if ($ColumnSpan -and $RowSpan) {
                    $body.size = @{rowSpan=$RowSpan;columnSpan=$ColumnSpan}
                }

                if ($Setting) {
                    $body.settings = $Setting
                }

                $invokeParams.PSTypeName = "$Organization.Widget", "$Organization.$project.Widget", 'PSDevOps.Widget'
            }
            $invokeParams.Body = $body

            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("POST $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Removing $(@($ParameterSet -split '/')[-1])" "$Organization $Project $Team" -Id $id -Completed
    }
}


