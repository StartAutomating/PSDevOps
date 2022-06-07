#requires -Module PSDevOps
Push-Location $PSScriptRoot

New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, HelpOut, RunEZOut -Environment @{
    SYSTEM_ACCESSTOKEN = '${{ secrets.AZUREDEVOPSPAT }}'
    NoCoverage = $true
}|
    Set-Content .\.github\workflows\TestAndPublish.yml -Encoding UTF8 -PassThru


New-GitHubWorkflow -Name "Trace On Issue Opened Or Edited" -On IssueOpenedOrEdited -Job TraceGitHubEvent |
    Set-Content .\.github\workflows\TraceIssueOpenedOrEdited.yml -Encoding UTF8 -PassThru

New-GitHubWorkflow -Name "Trace On Issue Closed" -On IssueClosed -Job TraceGitHubEvent |
    Set-Content .\.github\workflows\TraceIssueClosed.yml -Encoding UTF8 -PassThru

New-GitHubWorkflow -Name "Trace On Issue Comment" -On IssueComment -Job TraceGitHubEvent |
    Set-Content .\.github\workflows\TraceIssueComment.yml -Encoding UTF8 -PassThru

Pop-Location