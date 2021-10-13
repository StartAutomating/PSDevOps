@{
    ModuleVersion = '0.5.5.1'
    RootModule = 'PSDevOps.psm1'
    Description = 'PowerShell Tools for DevOps'
    Guid = 'e6b56c5f-41ac-4ba4-8b88-2c063f683176'
    PrivateData = @{
        PSData = @{
            Tags = 'ADO', 'AzureDevOps', 'PSDevOps', 'DevOps'
            ProjectURI = 'https://github.com/StartAutomating/PSDevOps'
            LicenseURI = 'https://github.com/StartAutomating/PSDevOps/blob/master/LICENSE'
            ReleaseNotes = @'
0.5.5.1:
---
* Allowing for [Reflection.AssemblyMetaData] attributes on step .ps1 files (to customize YAML).  Issue #123
* Better support for Object and array parameters in Azure DevOps. Issue #125.

0.5.5:
---
* Azure DevOps: Adding support for Shared Queries (Fixes #117)
** Get-ADOWorkItem -SharedQuery can get shared queries
** New-ADOWorkItem -WIQL will create shared queries.  -FolderName will create folders.
** Remove-ADOWorkItem -QueryID can remove a shared query by ID
* GitHub Workflows:
** Adding Job/Step definitions to Release Module
** Adding -NoCoverage to RunPester Step
** Creating Example workflow that publishes PSDevOps.

0.5.4.2:
---
* Adding Register-ADOArtifactFeed (Fixes #118)

0.5.4.1:
---
* Fixing Invoke-ADORestApi issues:  #111,#114,#115
* Attaching .BuildID and .DefinitionID properties to Get-ADOBuild where appropriate.

0.5.4:
---
* Formatting Improvments:
** Get-ADOField now includes .Type
** Get-ADOExtension now includes .Version
* Set-ADOTeam -DefaultAreaPath/-AreaPath parameter set issue fixed (fixes #103 / #92)
** Added tests for Set-ADOTeam
* GitHub Workflow Definition Improvements:
** New Triggers:
*** On PullToMain
** New Jobs:
*** UpdateModuleTag
*** PublishToGallery
** New Steps:
*** PublishPowerShellGallery
*** TagModuleVersion
* New-GitHubWorkflow/New-ADOPipeline now support -RootDirectory
* Fixing pluralization / list issue with multiple GitHub Workflow "On"
0.5.3
---
* Get-ADORepository  :  Adding -PullRequestID
* New/Set-ADOWorkItem:  Fixing pipelining issue

0.5.2
---
* Get-ADOTeam:  Adding alias -AreaPath for -TeamFieldValue, carrying on team property
* Set-ADOTeam:  Support for -DefaultAreaPath/-AreaPath (TeamFieldValues api, fixing issue #92)
* Get-ADOTest:  Enabling pagination and filtering of results.
** Invoke-ADORestAPI:  Fixing -Cache(ing) correctly (#88)
** Invoke-GitHubRESTAPI: Only using .ContentEncoding if present in results (PowerShell core fix)
* Get-ADOWorkItem:
** Fixing -Related (#79)
** Fixing -Comment errors when there are no commments (#80)
* New/Set-ADOWorkItem:
** Adding -Relationship and -Comment (#81)
** Improving Formatting of Work Items (#82)
** Adding -Tag
* Invoke-ADORestAPI:  Fixing issue with -QueryParameter
0.5.1
---
* Bugfixes:
** Get-ADOTest:  Fixing parameter sets and adding formatting.
** Invoke-GitHubRESTAPI:  Only using .ContentEncoding when present.
0.5
---
* Improved Git Functionality
** New-GitHubAction
** Invoke-GitHubRESTApi
** Connect/Disconnect-GitHub (enabling smart aliases like api.github.com/zen and api.github.com/repos/<owner>/<repo>)
** Formatting for GitHub Issues and Repos
* Azure DevOps Additions/Fixes
** Invoke-ADORestAPI -AsJob

** Get-ADOArtifactFeed now has -Metric, -PackageList, -PackageVersionList, -Provenance
** Get-ADOIdentity [new]
** Get-ADOProject now has -Board, -TestVariable, -TestConfiguration
** Get-ADOPermission is now more API-complete and has parameter sets for permission types
** Set-ADOPermission
** Get-ADOExtension can now read extension data
** Set-ADOExtension can now set extension data
** Get-ADOTest [new]
** New-ADOPipeline now has -RootDirectory
** Tons of New Type Definitions and Formatters

0.4.9
---
* New Command: Wait-ADOBuild
* Start-ADOBuild
** Supports -Debug (to start a build with extra tracing)
** Allows parameters as PSObject
* Get-ADORepository:  Added -IncludeHidden, -IncludeRemoteURL, -IncludeLink
* Improvements to Pipelines and Workflows:
** Pester, PSScriptAnalyzer, and ScriptCop now produce output variables
** PSDevOps now includes a file to generate it's own build
** PublishTest/CodeCoverage Results steps will always() run
** Convert-BuildStep will add a .Name to each script step.
'@
        }
        Colors = @{
            Build = @{
                Succeeded = '#00ff00'
                Failed = '#ff0000'
            }
        }
    }
    FormatsToProcess = 'PSDevOps.format.ps1xml'
    TypesToProcess = 'PSDevOps.types.ps1xml'
    Author = 'James Brundage'
    Copyright = '2019 Start-Automating'
    PowerShellVersion ='3.0'
}