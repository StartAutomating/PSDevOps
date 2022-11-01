#requires -Module PSDevOps
New-GitHubAction -Name "UsePSDevOps" -Description 'PowerShell Tools for DevOps (including a PowerShell wrapper for the GitHub REST API)' -Action PSDevOpsAction -Icon activity |
    Set-Content .\action.yml -Encoding UTF8 -PassThru


