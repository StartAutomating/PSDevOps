<#
.Synopsis
    Test Plans Extension
.Description
    Gets, Creates, or Updates test plans
#>
[CmdletBinding(DefaultParameterSetName='/{ProjectID}/_apis/testplan/plans')]
[Management.Automation.Cmdlet("Get","ADOTest")]
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Management.Automation.Cmdlet("Remove","ADOTest")]
param(
# If set, will return test results within a run.
[Management.Automation.Cmdlet("Get","ADOTest")]
[Parameter(Mandatory)]
[Alias('TestPlans')]
[switch]
$TestPlan,

# The test plan ID
[Parameter(Mandatory,ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[string]
$TestPlanID,

# The name of the test plan
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('PlanName')]
[string]
$TestPlanName,

# A description of the test plan
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('PlanDescription')]
[string]
$TestPlanDescription,

# The build identifier
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('BuildID')]
[int]
$TestBuildID,

# The area path for the test plan
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('AreaPath')]
[string]
$TestPlanAreaPath,

# The iteration path for the test plan
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('IterationPath')]
[string]
$TestPlanIteratonPath,

# The start date for the test plan
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('StartDate')]
[DateTime]
$TestPlanStartDate,

# The end date for the test plan
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('EndDate')]
[DateTime]
$TestPlanEndDate,

# The build definiton ID.
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[Alias('DefinitionID')]
[int]
$BuildDefinitionID,

# The build definition name.
[Management.Automation.Cmdlet("Add","ADOTest")]
[Management.Automation.Cmdlet("Set","ADOTest")]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans',ValueFromPipelineByPropertyName)]
[Parameter(ParameterSetName='/{ProjectID}/_apis/testplan/plans/{TestPlanID}',ValueFromPipelineByPropertyName)]
[int]
$BuildDefinitionName
)

process {
    $carryOn = @{
        ProjectID    = $ProjectID
        Organization = $organization
    }
    if ($TestPlanID) {
        $carryOn += @{TestPlanID=$TestPlanID}
    }
    $invokeSplat = @{
        Uri = $PSCmdlet.ParameterSetName
        UrlParameter = $carryOn
        Activity = "Test Plans"
        PSTypeName = @(
            "$organization.$ProjectID.TestPlan"
            "$organization.TestPlan"
            "PSDevOps.TestPlan"
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
                PlanID = $TestPlanID
            }
        }
        $body = [Ordered]@{}
        if ($TestPlanName)          { $body.name = $TestPlanName }
        if ($TestPlanDescription)   { $body.description = $TestPlanDescription }
        if ($TestPlanAreaPath)      { $body.areaPath = $TestPlanAreaPath }
        if ($TestPlanIterationPath) { $body.iterationPath = $TestPlanIterationPath }
        if ($TestBuildID)           { $body.buildID = $TestBuildID }
        if ($TestPlanStartDate)     { $body.startDate = $TestPlanStartDate.ToString('o') }
        if ($TestPlanEndDate)       { $body.endDate = $TestPlanEndDate.ToString('o') }
        if ($TestPlanOwner)         { $body.owner = $TestPlanOwner | Select-Object -Property _links, descriptor, id, isDeletedInOrigin }
        if ($BuildDefinitionID) {
            if (-not $body.buildDefinition) {
                $body.buildDefinition = @{}
            }
            $body.buildDefinition.id = $BuildDefinitionID
        }
        if ($BuildDefinitionName) {
            if (-not $body.buildDefinition) {
                $body.buildDefinition = @{}
            }
            $body.buildDefinition.name = $BuildDefinitionName
        }
        $invokeSplat.Body = $body
    }

    if ($commandName -eq 'Remove-ADOTest') {
        $invokeSplat.Method = 'DELETE'
    }
    $invokeSplat
}