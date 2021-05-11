Write-FormatView -TypeName PSDevOps.WorkItem.Comment -Property CreatedBy, CreatedAt, Comment -Wrap -VirtualProperty @{
    CreatedBy = { $_.CreatedBy.displayName }
} -GroupByProperty WorkItemID
