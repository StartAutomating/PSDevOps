Write-FormatView -TypeName PSDevOps.Picklist -Property Name, Type, IsSuggested, PicklistID 

Write-FormatView -TypeName PSDevOps.Picklist.Detail -Property Name, Type, PicklistID, IsSuggested, Items -Wrap -VirtualProperty @{
    Items = { $_.Items -join [Environment]::NewLine }
}

Write-FormatView -TypeName PSDevOps.Picklist, PSDevOps.Picklist.Detail -Property Name, PicklistID -Name ID