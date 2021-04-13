@{
    ModuleVersion = '0.5'
    RootModule = 'PSDevOps.psm1'
    Description = 'PowerShell Tools for DevOps'
    Guid = 'e6b56c5f-41ac-4ba4-8b88-2c063f683176'
    PrivateData = @{
        PSData = @{
            Tags = 'ADO', 'AzureDevOps', 'PSDevOps', 'DevOps'
            ProjectURI = 'https://github.com/StartAutomating/PSDevOps'
            LicenseURI = 'https://github.com/StartAutomating/PSDevOps/blob/master/LICENSE'
            ReleaseNotes = @'
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
0.4.8
---
* Improved Tracing
** New Commands: Write-ADOOutput, Trace-ADOCommand/GitHubCommand
** Renaming Command / Adding Parameters:  Set-ADOVariable -> Write-ADOVariable.  Added -IsOutput & -IsReadOnly.
** Adding Trace-GitHubCommand/ADOCommand
** Improved logging of parameters in Convert-BuildStep
* New Functionality in Azure DevOps:
** Get-ADOProject now has -TestRun, -TestPlan, -Release, and -PendingApproval (and better progress bars)
** Get-ADOWorkItemType now has -Field
** Commands for Picklists:  Add/Get/Remove/Update-ADOPicklist
0.4.7
----
* New Commands:
** Add/Get/Remove-ADOWiki
** Get-ADOPermission
* Bugfixes:
** Honoring Get-ADOBuild -DefinitionName
* Disconnect-ADO is now run prior at the start of Connect-ADO, and on module unload.
0.4.6
---
* New-ADOPipeline/New-GitHubWorkflow:  Adding -BuildScript
* Connect-ADO:  Auto-detecting connected user's teams and adding tab completion for -Project/-ProjectID/-Team/-TeamID
* Convert-BuildStep: Re-ordering YAML for GitHub Workflows (putting .runs last)
* Convert-ADOPipeline:  Not returning .inputs when there are no .inputs
* Get-ADOProject:  Adding -PolicyType and -PolicyConfiguration
* Get-ADORepository:  Adding -PullRequest, -SourceReference, -TargetReference, -ReviewerIdentity, -CreatorIdentity.
* Get-ADOBuild:  Adding -DefinitionName
* Invoke-ADORestAPI:  Passing content length of 0 when body is empty.
* Updating README
0.4.5
---
* New Commands:
** Connect/Disconnect-ADO:  Caching connection info and saving default parameters!
** New-ADOBuild          :  Create build definitions!
** Remove-ADOAgentPool   :  Cleaning up pools, queues, and agents.
* Core Improvements
** Invoke-ADORestApi
*** Now supports -ContinuationToken (and auto-continues unless passed a $first or $top query parameter)
*** Caches access tokens.
*** BREAKING: Invoke-ADORestApi No longer has -Proxy* parameters.
* Updated Commands:
** Get-ADOUser/Get-ADOTeam : Additional Graph scenarios added.
** New/Set-ADOWorkItem     : Added -BypassRule, -ValidateOnly, -SkipNotification
0.4.4
---
* Get-ADOTask:  Adding -YAMLSchema.
* Get-ADOTeam:  Adding -Setting/-FieldValue/-Iteration/-Board.
* Get-ADOAreaPath/ADOIterationPath:  Making parameter names match cmdlet.  Honoring -AreaPath/-IterationPath.
* Get-ADOProject:  Adding -ProcessConfiguration, -Plan, -PlanID, and -DeliveryTimeline.
* New Command:  Set-ADOTeam
0.4.3
---
*Renaming commands:
** New-ADODashboard -> Add-ADODashboard
** New-ADOTeam -> Add-ADOTeam
* Add-ADOTeam can now add members to a team
* Get-ADOTeam can now get an -Identity
* New Command: Get-ADOUser
* Get-ADOAgentPool:  Fixed pipelining bug, added -AgentName/-IncludeCapability/-IncludeLastCompletedRequest/-IncludeAssignedRequest.
* Set-ADOProject:  Can now -EnableFeature and -DisableFeature
0.4.2
---
* Build Step Improvements:
** New-ADOPipeline now has -PowerShellCore and -WindowsPowerShell
** Import-BuildStep now has parameter sets
** New-ADOPipeline/New-GitHubWorkflow now refer to a metadata collection based off of their noun.
** BuildStep directories can be aliased:
*** ADOPipeline directories can be: ADOPipeline, ADO, AzDo, and AzureDevOps.
*** GitHubWorkflow directories can be: GitHubWorkflow, GitHubWorkflows, and GitHub.
* New Dashboard Commands: Clear/Update-ADODashboard
* New Extension Commands: Enable/Disbale-ADOExtension
* Improved formatting/types for Extensions.
* Breaking change: Install/Uninstall-ADOExtension now accept -PublisherID and -ExtensionID, not -PublisherName and -ExtensionName.
0.4.1
---
* More GitHub Functionality:
** Write-GitHubDebug
** Write-GitHubOutput
** Hide-GitHubOutput
** New-GitHubWorkflow allows for more complex event mapping.
* Azure DevOps Pipeline Changes
** Convert-BuildStep once again converts using ${{parameters}} syntax
* New/Improved Azure DevOps Cmdlets
** Get/New/Remove-ADODashboard
** Get-ADOAgentPool now supports -PoolID
** Set-ADOProject
** Repositories returned from a build definition are now decorated as PSDevOps.Repository
* Improved testing and static analysis compliance
0.4
---
* Overhaul of GitHub Workflow functionality.
** New-GitHubAction renamed to New-GitHubWorkflow
** /GitHubActions renamed to /GitHub
** Added -EventParameter to allow for parameters from events such as workflow_dispatch
** Added Write-GitHubError/GitHubWarning (updating Write-ADOError/Write-ADOWarning for consistency)
** Cleaning up GitHub Workflow parts
* Get-ADOTask no longer has -ApiVersion parameter
0.3.9
---
* New/Get/Remove-ADOWorkItemType:  Create/get/remove work custom work item types, states, rules, and behaviors.
* Added Get-ADOBuild -IncludeAllProperty/-IncludeLatestBuild.
* ScriptCop Integration:  PowerShelllStaticAnalysis stage now runs ScriptCop as well.
* Improved ScriptAnalyzer Integration: Rule name is now outputted.
0.3.8
---
* Add/Remove-ADOAreaPath
* Formatter for AreaPaths

0.3.7
---
* Convert-ADOPipeline now has -Passthru and -Wherefore
* Get-ADOWorkProcess now has -Behavior and -WorkItemType
* Get-ADOWorkItem now has -Mine, -CurrentIteration, -Comment, -Update, -Revision.

0.3.6.1
---
* Convert-ADOPipeline now binds to .Variables property
* Fixing bug in PSDevOps.WorkItem types file, which displayed in formatting.
0.3.6
---
* Added: Get-ADOTask, Convert-ADOPipeline
0.3.5
---
* New Command: Get-ADOTeam
* Get-ADOBuild -CodeCoverage
* Progress bars on Get-ADORepository
* Slight refactoring to make progress bars easier in any function

0.3.4.1
---
* Removing supplied parameters in commands generated by Import-ADOProxy.
0.3.4
---
* New capability: Import-ADOProxy (Import a proxy module with for your ADO / TFS instance)
* New REST Commands: Get-ADOAreaPath, Get-ADOIterationPath, Get-ADOExtension
* More Features: Get-ADORepository -FileList
* Massive Internal Refactoring (switching to dynamic parameters for -PersonalAccessToken etc, standardizing pstypenames)
0.3.3
---
* Now Caching Personal Access Tokens!
* URLEncoding all segments in Parts/ReplaceRouteParameter.
* Ensuring all Azure DevOps YAML Parameters are wrapped in a string.
0.3.2
---
* Pester workarounds - Steps/InstallPester and Steps/RunPester now accept a PesterMaxVersion (defaulting to 4.99.99)
* Convert-BuildStep handles blank parameter defaults correctly
* Get-ADOBuild can get yaml definitions directly, e.g Get-ADOBuild -DefinitionID 123 -DefinitionYaml
0.3.1
---
* Bugfixes and Improvements to Convert/Import/Expand-BuildStep:
1. Enforcing pluralization of certain fields within Azure DevOps
2. Handling [string[]], [int[]], [float[]], or [ScriptBlock] parameters
* Allowing lists of primitives to not be indented in YAML.
0.3.0
---
* Added Convert/Import/Expand-BuildStep
* Allowing build steps to be defined in functions
* Automagically importing build step parameters
0.2.9
---
* Get/New/Remove-ADORepository
* Get/New/Remove-ADOServiceEndpoint
* Get-ADOAgentPool
** Improvements to New-ADOPipeline to avoid unexpected singletons
0.2.8
---
* Get/New/Update-ADOBuild
* Improving New-ADOPipeline:
** Unknown -InputObject properties will no longer be pluralized
** Added 'Pool' to list of known singletons
0.2.7
---
* New Cmdlet: Set-ADOArtifactFeed
* Improvements to New/Get/Remove-ADOArtifactFeed (better pipelining, renaming -FullyQualifiedID to -FeedID)
0.2.6
---
* New Cmdlets:
** New/Get/Remove-ADOArtifactFeed
** New/Remove-ADOProject
** New-GitHubAction
0.2.5
---
* Improving Get-ADOWorkItem:
** -Title allows getting work items by title
** -NoDetail allows for queries to only return IDs
** Passing -Field will skip formatting
** WorkItemsBatch will be used for query results.
** Passing an old -ApiVersion will not use workItemsBatch
** Formatting improved
* Adding Get-ADOWorkProcess
* Fixing issues with -ADOField commands when not provided a -Project
0.2.4
---
* Adding Adding -CanSortBy, -IsQueryable, and -ReadOnly to New-ADOField.
* Adding parameter help to New-ADOField
0.2.3
---
* Adding New/Remove-ADOField
* Adding help to Get-ADOField
* Adding formatting for fields
0.2.2
---
* Adding New/Set/Remove-ADOWorkItem
* Adding Get-ADOField
* New Parameter: Get-ADOWorkItem -WorkItemType
* New Parameter: New-ADOPipeline -Option
* Initial formatting
* Switching Parts to use latest VMImage

0.2.1 :
* Added Get-ADOWorkItem
---
0.2   :
---
* Added Invoke-ADORestAPI
0.1    :
---
Initial Commit
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