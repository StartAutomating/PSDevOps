Write-FormatView -TypeName PSDevOps.Team -Property ProjectName, Team, Description

Write-FormatView -TypeName PSDevOps.Team -Name ID -Property ProjectName, ProjectID, Team, TeamID

Write-FormatView -TypeName PSDevOps.Team -Name URL -Property ProjectName, Team, Url -Wrap
