<#
.Synopsis
    Test Suite Extension
.Description
    Gets, Creates, or Updates test suites
#>
[CmdletBinding(DefaultParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites')]
[Management.Automation.Cmdlet("Get","ADOTest")]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Management.Automation.Cmdlet("Remove","ADOTest")]
param(
# The Test Plan ID
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[string]
$TestPlanID,

# If set, will list test suites.
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites')]
[Alias('TestSuites')]
[Management.Automation.Cmdlet("Get","ADOTest")]
[switch]
$TestSuite,

# The test suite identifier.
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Management.Automation.Cmdlet("Remove","ADOTest")]
[string]
$TestSuiteID,

# The name of the test suite.
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[string]
$TestSuiteName,

# The parent test suite ID
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[string]
$ParentTestSuiteID,

# If set, will inherit the default configuration.
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Alias('inheritDefaultConfigurations')]
[switch]
$InheritDefaultConfiguration,

# The test suite type.
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[ValidateSet("DynamicTestSuite","RequirementTestSuite","StaticTestSuite","None")]
[string]
$TestSuiteType,

# One or requirement identifiers.
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[string]
$RequirementId,

# A test query
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[string]
$QueryString,

# One or more test configuration identifiers.
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}/suites/{TestSuiteID}',ValueFromPipelineByPropertyName)]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[string[]]
$TestConfigurationID
)

process {
    $carryOn = @{
        ProjectID    = $ProjectID
        Organization = $organization
        TestPlanID   = $TestPlanID
    }
    $invokeSplat = @{
        Uri = $PSCmdlet.ParameterSetName
        UrlParameter = $carryOn
        Activity = "Test Plans"
        PSTypeName = @(
            "$organization.$ProjectID.TestSuite"
            "$organization.TestSuite"
            "PSDevOps.TestSuite"
        )
        Property = $carryOn
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
        if ($TestSuiteName)         { $body.name = $TestSuiteName }                        
        if ($TestSuiteType)         { $body.suiteType = $TestSuiteType }
        if ($ParentTestSuiteID)     { $body.parentSuite = @{id=$ParentTestSuiteID}}
        if ($RequirementId)         { $body.requirementID = $RequirementId }
        if ($QueryString)           { $body.queryString = $QueryString }
        if ($TestConfigurationID)   {
            $body.defaultConfigurations = @(foreach ($tci in $TestConfigurationID) { @{id=$tci}})
        }
        
        $body.inheritDefaultConfigurations = $InheritDefaultConfiguration -as [bool]
        $invokeSplat.Body = $body
    }

    if ($commandName -eq 'Remove-ADOTest') {
        $invokeSplat.Method = 'DELETE'
    }
    $invokeSplat
}