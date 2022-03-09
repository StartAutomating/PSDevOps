function Get-ADOTest
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
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/test/runs/list
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/test/results/list
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/test/test%20%20suites/list
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/testplan/test%20%20suites/get%20test%20suites%20for%20plan
    #>
    [OutputType('PSDevOps.TestPlan','PSDevOps.TestRun', 'PSDevOps.TestSuite', 'PSDevOps.TestPoint','PSDevOps.TestCase')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project identifier.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $ProjectID,

    # If set, will return the test runs associated with a project.
    [Parameter(ParameterSetName='/{ProjectID}/_apis/test/runs')]
    [Alias('TestRuns')]
    [switch]
    $TestRun,

    
    # If set, will return the test plans associated with a project.
    [Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans')]
    [Alias('TestPlans')]
    [switch]
    $TestPlan,

    # If set, will return the test suites associated with a project and plan.
    [Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites')]
    [Alias('TestSuites')]
    [switch]
    $TestSuite,

    # If set, will return results related to a specific test run.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/attachments')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/results')]
    [string]
    $TestRunID,
        
    # If set, will return the test variables associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/test/variables')]
    [Alias('TestVariables')]
    [switch]
    $TestVariable,

    # If set, will return the test variables associated with a project.
    [Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/test/configurations')]
    [Alias('TestConfigurations')]
    [switch]
    $TestConfiguration,

    # If set, will return the first N results within a test run.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/results')]
    [Alias('Top')]
    [int]$First,

    # If provided, will return the continue to return results of the maximum batch size until the total is reached.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/results')]
    [Alias('TotalTests','TestCount')]
    [int]$Total,

    # If set, will return the skip N results within a test run.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/results')]
    [int]$Skip,

    # If provided, will only return test results with one of the provided outcomes.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/results')]
    [ValidateSet('Unspecified','None','Passed','Failed','Inconclusive','Timeout','Aborted','Blocked','NotExecuted','Warning','Error','NotApplicable','Passed','InProgress','NotImpacted')]
    [string[]]$Outcome,

    # Details to include with the test results.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/results')]
    [Alias('ResultDetails')]
    [ValidateSet('None', 'Iterations','WorkItems')]
    [string[]]$ResultDetail,

    # If set, will return test attachments to a run.
    [Parameter(Mandatory,
        ParameterSetName='/{ProjectID}/_apis/test/runs/{TestRunID}/attachments')]
    [Alias('TestAttachments')]
    [switch]
    $TestAttachment,

    # If set, will always retrieve fresh data.
    # By default, cached data will be returned.
    [switch]
    $Force,

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

    dynamicParam { . $GetInvokeParameters -CommandName $MyInvocation.MyCommand.Name -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q  = [Collections.Queue]::new()
        $rq = [Collections.Queue]::new()
    }
    process {
        $in = $_
        $paramCopy = [Ordered]@{} + $psBoundParameters
        $myCommandName       = $MyInvocation.MyCommand.name
        $extensionOutput     = Get-PSDevOpsExtension -Run -CommandName $myCommandName -Parameter $paramCopy -Stream
        if ($extensionOutput) {
            foreach ($extOut in $extensionOutput) {
                $rq.Enqueue($extOut)
            }
        } else {
            $q.Enqueue(@{PSParameterSet=$psCmdlet.ParameterSetName;InputObject=$in} + $paramCopy)
        }        
    }
    end {
        $c, $t, $progId = 0, ($q.Count + $rq.Count), [Random]::new().Next()
        . $flushRequestQueue -Invoker Invoke-ADORestAPI
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
                    'TestPlan', 'Plan' -replace 'TestPoint','Point' -replace
                    '(Plan|Point|Run|Suite|Configuration|Attachment|Result)', 'Test$0'

            $additionalProperty = @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
            if ($ProjectID)   { $additionalProperty.ProjectID = $ProjectID }            
            if ($inputObject.TestPlanName) {
                $additionalProperty['TestPlanName'] = $inputObject.TestPlanName
            }
            if ($TestSuiteID) { $additionalProperty.TestSuiteID = $TestSuiteID }
            $invokeParams.Uri = $uri
            $invokeParams.PSTypeName = "$Organization.$typeName", "PSDevOps.$typeName"
            $invokeParams.Property = $additionalProperty
            $queryParams = @{}

            if ($ResultDetail) {
                $queryParams.detailsToInclude = $ResultDetail -join ','
            }
            if ($Outcome) {
                $queryParams.outcomes = $Outcome -join ','
            }
            $invokeParams.QueryParameter = $queryParams
            if (-not $Force) { $invokeParams.Cache = $true }
            if ($First) { $queryParams.'$top'  = $First }
            if ($Skip)  { $queryParams.'$skip' = $Skip  }
            if ($Total) {
                $Count = 0
                $innerProgressId = Get-Random
                do {
                    $resultBatch = @(Invoke-ADORestAPI @invokeParams)
                    $count += $resultBatch.Length
                    $skip = $queryParams.'$skip' = $count
                    Write-Progress "Getting Results" " [$Count/$total] $uri" -PercentComplete (
                        $Count * 100 / $Total
                    ) -ParentId $progId -Id $innerProgressId
                    if ($resultBatch.Length) {
                        $resultBatch
                    }
                } while ($resultBatch -and ($count -lt $Total))
                Write-Progress "Getting Results" " [$Count/$total] $uri" -Completed -ParentId $progId -Id $innerProgressId
            } else {
                Invoke-ADORestAPI @invokeParams
            }

        }
        if ($c -gt 0) {
            Write-Progress "$($MyInvocation.MyCommand)" "[$c/$t]" -Completed -Id $progId
        }
        
    }
}


