Write-FormatView -TypeName PSDevOps.ExtensionContribution -Action {
    Write-FormatViewExpression -Text 'ContributionID: '
    Write-FormatViewExpression -ScriptBlock { $_.ContributionID +[Environment]::NewLine }
    Write-FormatViewExpression -If { $_.Name } -ScriptBlock { '  ' + $_.Name } 
    Write-FormatViewExpression -If { $_.Description } -ScriptBlock { [Environment]::NewLine + '    ' + $_.Description }
} # -GroupByProperty ContributionID -GroupLabel ContributionID
