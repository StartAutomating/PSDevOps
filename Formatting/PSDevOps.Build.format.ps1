Write-FormatView -TypeName PSDevOps.Build -Action {
    Write-FormatViewExpression -ScriptBlock { $_.Definition.Name + ' ' + $_.BuildNumber + ' [' }
    
    Write-FormatViewExpression -ForegroundColor 'PSDevOps.Build.Succeeded' -If {
        $_.Result -eq 'Succeeded'
    } -ScriptBlock {
        $_.Result
    }

    Write-FormatViewExpression -ForegroundColor 'PSDevOps.Build.Failed' -If {
        $_.Result -eq 'Failed'
    } -ScriptBlock {
        $_.Result
    }

    Write-FormatViewExpression -ForegroundColor 'PSDevOps.Build.NotStarted' -If {
        $_.Status -eq 'notStarted'
    } -ScriptBlock {
        $_.Status
    }

    Write-FormatViewExpression -ForegroundColor 'PSDevOps.Build.InProgress' -If {
        $_.Status -eq 'inProgress'
    } -ScriptBlock {
        if ($_.QueueTime -and -not $_.StartTime) {
            'Queued'
        } elseif ($_.StartTime -and -not $_.FinishTime) {
            'Running'
        }        
    }

    Write-FormatViewExpression -ScriptBlock {
        if ($_.Status -eq 'inProgress') {
            if ($_.QueueTime -and -not $_.StartTime) {
                ' for ' + ([DateTime]::Now - $([Datetime]$_.QueueTime).ToLocalTime()).ToString().Substring(0,8)
            } else {
                ' for ' + ([DateTime]::Now - $([DateTime]$_.StartTime).ToLocalTime()).ToString().Substring(0,8)
            }
        } else {
            " in " + ([DateTime]($_.FinishTime) - [DateTime]($_.StartTime)).ToString().Substring(0,8)
        }    
    }

    Write-FormatViewExpression -Text ']'
    
    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -ScriptBlock {
        '=' * ($_.Definition.Name.Length + 
            $_.BuildNumber.Length + 
            $_.Result.Length + 4 + $(
                if ($_.FinishTime) { 4 + 8 }
                else { 
                    5 + 8 + $(if (-not $_.StartTime) { 'Queued'.Length} else { 'Running'.Length }) 
                })
            )
    }
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock {
        $_.Reason + ' of ' + $_.sourceBranch + ' for ' + $_.RequestedFor.DisplayName 
    }

    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock {
        '-' * ($_.Reason.Length + 4 + $_.sourceBranch.Length + 5 + $_.RequestedFor.DisplayName.Length)
    }

    Write-FormatViewExpression -Newline
    
    Write-FormatViewExpression -If { $_.ChangeSet } -ScriptBlock {
        "### Changes:" + [Environment]::NewLine
    }
    Write-FormatViewExpression -If { $_.ChangeSet } -ScriptBlock {
        '  * ' + (@($_.ChangeSet | Select-Object -ExpandProperty Message) -join "$([Environment]::NewLine)  * ")
    }
}
