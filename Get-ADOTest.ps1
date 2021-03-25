﻿function Get-ADOTest
{
    <#
    .Synopsis
        Gets tests from Azure DevOps.
    .Description
        Gets test plans, suites, points, and results from Azure DevOps or TFS.
    .Example
        Get-ADOProject -Organization StartAutomating -Project PSDevOps |
            Get-ADOTest -Run
    .Link
        Get-ADOProject
    #>
    [OutputType('PSDevOps.Project','PSDevOps.Property')]
    param(
    # The project identifier.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/runs')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}/attachments')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}/results')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites/{TestSuiteID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites/{TestSuiteID}/points')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/variables')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/configurations')]
    [Alias('ProjectID')]
    [string]
    $Project,

    # If set, will return the test runs associated with a project.
    [Parameter(ParameterSetName='/{Project}/_apis/test/runs')]
    [Alias('TestRuns')]
    [switch]
    $TestRun,

    # If set, will return results related to a specific test run.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}/attachments')]
    [string]
    $TestRunID,

    # If set, will return the test plans associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{Project}/_apis/test/plans')]
    [Alias('TestPlans')]
    [switch]
    $TestPlan,

    # If set, will return results related to a specific test plan.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites')]
    [string]
    $TestPlanID,

    # If set, will return the test variables associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{Project}/_apis/test/variables')]
    [Alias('TestVariables')]
    [switch]
    $TestVariable,

    # If set, will return the test variables associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{Project}/_apis/test/configurations')]
    [Alias('TestConfigurations')]
    [switch]
    $TestConfiguration,

    # If set, will list test suites related to a plan.
    [Parameter(Mandatory,ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites')]
    [Alias('TestSuites')]
    [switch]
    $TestSuite,

    # If set, will return results related to a particular test suite.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites/{TestSuiteID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites/{TestSuiteID}/points')]
    [string]
    $TestSuiteID,

    # If set, will return test points within a suite.
    [Parameter(Mandatory,
        ParameterSetName='/{Project}/_apis/test/plans/{TestPlanID}/suites/{TestSuiteID}/points')]
    [Alias('TestPoints')]
    [switch]
    $TestPoint,

    # If set, will return test results within a run.
    [Parameter(Mandatory,
        ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}/results')]
    [Alias('TestResults')]
    [switch]
    $TestResult,

    # If set, will return test attachments to a run.
    [Parameter(Mandatory,
        ParameterSetName='/{Project}/_apis/test/runs/{TestRunID}/attachment')]
    [Alias('TestAttachments')]
    [switch]
    $TestAttachment,

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
        $baseParams = @{} + $invokeParams
        $q = [Collections.Queue]::new()
    }
    process {
        $in = $_
        $psParameterSet = $psCmdlet.ParameterSetName

        $q.Enqueue(@{PSParameterSet=$psParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $dq $q

            $uri =
                "$(@(
                    "$server".TrimEnd('/')  # * The Server
                    "/$organization"
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
                    '(Plan|Run|Suite|Configuration|Point|Attachment|Result)', 'Test$0'

            $additionalProperty = @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
            if ($ProjectID) { $additionalProperty.ProjectID = $ProjectID }
            Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.$typeName",
                "PSDevOps.$typeName" -Property $additionalProperty
        }

        Write-Progress "Getting" "[$c/$t]" -Completed -Id $progId
    }
}