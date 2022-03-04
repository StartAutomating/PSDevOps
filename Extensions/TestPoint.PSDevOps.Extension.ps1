<#
.SYNOPSIS
    Test Points Extension
.DESCRIPTION
    Gets, Creates, or Updates test points
#>
[CmdletBinding(DefaultParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}/TestPoint')]
[Management.Automation.Cmdlet("Get","ADOTest")]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Management.Automation.Cmdlet("Remove","ADOTest")]
param(
[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[string]
$TestPlanID,

[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[string]
$TestSuiteID,

[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
[Alias('TestPoints')]
[switch]
$TestPoint
)


process {
    $invokeSplat = @{
        Uri = $PSCmdlet.ParameterSetName
        UrlParameter = @{
            ProjectID    = $ProjectID
            Organization = $organization
            TestPlanID   = $TestPlanID
            TestSuiteID  = $TestSuiteID
        }
        Activity = "Test Points"
        PSTypeName = @(
            "$organization.$ProjectID.TestPoint"
            "$organization.TestPoint"
            "PSDevOps.TestPoint"
        )
    }

    if ($commandName -in 'Add-ADOTest', 'Set-ADOTest')  {
        if ($commandName -eq 'Add-ADOTest') {
            $invokeSplat.Method = 'POST'
        }
        if ($commandName -eq 'Set-ADOTest') {
            $invokeSplat.Method = 'PATCH'
            $invokeSplat.UrlParameter += @{
                TestSuiteID = $TestSuiteID
            }
        }
        $body = [Ordered]@{}
        $invokeSplat.Body = $body
    }

    if ($commandName -eq 'Remove-ADOTest') {
        $invokeSplat.Method = 'DELETE'
    }
    $invokeSplat
}