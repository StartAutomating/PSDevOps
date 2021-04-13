Write-FormatView -TypeName PSDevOps.GitIssue -Property Number, State, Title -AutoSize -ColorRow {
    if ($_.labels.count -eq 1) { # If there's only one label
        '#' + $_.labels[0].color # use that color code.
    }
}
