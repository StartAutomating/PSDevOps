Write-FormatView -TypeName PSDevOps.TestRun -Property Name, IsAutomated, TotalTests, PassedTests -ColorRow {
    if ($_.PassedTests -lt $_.TotalTests) {
        if ($_.PassedTests -lt ($_.TotalTests / 2)) {
            'Red'
        } else {
            'Yellow'
        }
    } else {
        'Green'
    }
}
