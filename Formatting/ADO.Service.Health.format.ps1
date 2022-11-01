Write-FormatView -TypeName ADO.Service.Health -Action {
    Write-FormatViewExpression -If { $_.Status.Health -eq 'Healthy'} -ForegroundColor 'Success' -ScriptBlock {
        "Healthy @ $(($_.LastUpdated.ToLocalTime() | Out-String).Trim())"
    }
    Write-FormatViewExpression -If { $_.Status.Health -ne 'Healthy'} -ForegroundColor 'Warning' -ScriptBlock {
        "$($_.Status.Health) @ $(($_.LastUpdated.ToLocalTime() | Out-String).Trim())"
    }
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -Property Services -Enumerate -ControlName ADO.Service.Health.ServiceGeographies -if { $_.Status.Health -ne 'Healthy'}
}

Write-FormatView -Name ADO.Service.Health.ServiceGeographies -TypeName n/a -Action {
    Write-FormatViewExpression -If { -not @($_.geographies.Health -ne 'Healthy') } -ForegroundColor 'Success' -ScriptBlock {
        "* $($_.id)"
    }
    Write-FormatViewExpression -If { @($_.geographies.Health -ne 'Healthy')} -ForegroundColor 'Warning' -ScriptBlock {
        "* $($_.id)"
    }
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -If { @($_.geographies.Health -ne 'Healthy')} -ControlName ADO.Service.Health.Geography -Property geographies -Enumerate
} -AsControl

Write-FormatView -Name ADO.Service.Health.Geography -TypeName n/a -Action {
    Write-FormatViewExpression -If { $_.Health -eq 'Healthy'} -ForegroundColor 'Success' -ScriptBlock {
        "  * $($_.Name) (Healthy)"
    }
    Write-FormatViewExpression -If { $_.Health -ne 'Healthy'} -ForegroundColor 'Warning' -ScriptBlock {
        "  * $($_.Name) ($($_.Health))"
    }
    Write-FormatViewExpression -Newline
} -AsControl

