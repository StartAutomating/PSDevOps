#requires -Module PSDevOps
Push-Location $PSScriptRoot

New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildPSDevOps -Environment @{
    SYSTEM_ACCESSTOKEN = '${{ secrets.AZUREDEVOPSPAT }}'
    NoCoverage = $true
} -OutputPath .\.github\workflows\TestAndPublish.yml 

Import-BuildStep -ModuleName GitPub
New-GitHubWorkflow -On Issue, Demand -Job RunGitPub -Name OnIssueChanged |
    Set-Content (Join-Path $PSScriptRoot .github\workflows\OnIssue.yml) -Encoding UTF8 -PassThru


Pop-Location