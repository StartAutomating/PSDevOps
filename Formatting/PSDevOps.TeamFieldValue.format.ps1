Write-FormatView -TypeName PSDevOps.TeamFieldValue -Property Field, DefaultValue, Values  -VirtualProperty @{
    Values = {
            foreach ($v in $_.values) {
                if ($v.IncludeChildren) { 
                    "$($v.value)/*"
                } else {
                    "$($v.value)"
                }
            }
    }    
    Field = {
        $_.field.ReferenceName
    }
} 
