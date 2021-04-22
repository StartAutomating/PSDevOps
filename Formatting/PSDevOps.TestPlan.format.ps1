Write-FormatView -TypeName PSDevOps.TestPlan -Property Name, TestPlanID, Owner, State, AreaPath -Wrap -GroupByScript {
    $_.Project.Name
} -GroupLabel ProjectName
