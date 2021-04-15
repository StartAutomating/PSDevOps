Write-FormatView -TypeName PSDevOps.TestSuite -Property Name, TestSuiteID, LastUpdated, QueryString -Width 20, 12, 20, 0 -Wrap -GroupByProperty TestPlanName -VirtualProperty @{
    LastUpdated = {
        $_.LastUpdated.ToString('s')
    }
}
