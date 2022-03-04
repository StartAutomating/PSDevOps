function Add-ADOTest {
    <#
    .Synopsis
        Creates tests in Azure DevOps.
    .Description
        Creates test plans, suites, points, and results in Azure DevOps or TFS.    
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

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1"
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
        $extensionOutput     = Get-PSDevOpsExtension -Run -CommandName $MyInvocation.MyCommand.Name -Parameter $paramCopy -Stream
        if ($extensionOutput) {
            foreach ($extOut in $extensionOutput) {
                $rq.Enqueue($extOut)
            }
        } else {
            $q.Enqueue(@{PSParameterSet=$psCmdlet.ParameterSetName;InputObject=$in} + $paramCopy)
        }
    }
    end {        
        . $flushRequestQueue -Invoker Invoke-ADORestApi                    
    }
}
