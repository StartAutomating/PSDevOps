PSDevOps
========
PowerShell Tools for DevOps
---------------------------
[![Build Status](https://dev.azure.com/StartAutomating/PSDevOps/_apis/build/status/StartAutomating.PSDevOps?branchName=master)](https://dev.azure.com/StartAutomating/PSDevOps/_build/latest?definitionId=5)
---------------------------

__PSDevOps helps you automate DevOps using PowerShell.__

Using PSDevOps, you can:

* [Automate Azure DevOps](#Automate-Azure-DevOps)
* [Creating Complex Pipelines](#Creating-Complex-Pipelines)
* [Write GitHub Workflows](#Write-GitHub-Workflows)

### Automate Azure DevOps

The Azure DevOps REST API can be challenging to work with, and hard to remember.

PSDevOps provides dozens of commands to automate Azure DevOps.

Commands are named simply and clearly, using PowerShell's verb-noun convention, for example, Get-ADOProject, Get-ADORepository, Get-ADOBuild

To see all commands from PSDevOps, run:

~~~PowerShell
Get-Command -Module PSDevOps
~~~

Unlike many modules, these commands make use of the full feature set of PowerShell.
Here are a few things PSDevOps does differently:

#### Using the Object Pipeline

The Object Pipeline is a core feature of PowerShell that allows you to send structured information from step to step.

Almost every function in PSDevOps is "pipeline aware", and can accept multiple types of objects

~~~PowerShell
Connect-ADO -Organization $MyOrganization -PersonalAccessToken $MyPat
Get-ADOProject | Get-ADOTeam | Get-ADODashboard
~~~

Many commands can be piped back into themselves to return additional results, for instance:

~~~PowerShell
Get-ADOBuild -Project MyProject -First 5 | # Get the first 5 builds 
    Get-ADOBuild -ChangeSet # Get the associated changesets.
~~~

~~~PowerShell
Get-ADOAgentPool | # Gets agent pools from the organization
    Get-ADOAgentPool  # Gets individual agents within a pool, because the prior object returned a PoolID.
~~~


#### Help

Like any good PowerShell module, PSDevOps has help.  Run Get-Help on any command to learn more about how to use it.

~~~PowerShell
Get-Help Get-ADOBuild -Full
~~~

Commands that wrap the REST api should have a .LINK to the MSDN documentation on the API to help you understand what they are doing.

#### Custom Formatting

The Azure DevOps REST API can return a lot of unhelpful information.
To make it easier to work with Azure DevOps in Powershell, PSDevOps includes several custom formatters.

For a simple example, try running one of the following commands:

~~~PowerShell
Get-ADOProject
~~~

~~~PowerShell
Get-ADOTeam -Mine
~~~

#### Extended Types

The Azure DevOps REST api often returns data that is inconsistently named or weakly typed.  

Where possible, PSDevOps uses the Extended Type System in PowerShell to augment the values returned from Azure DevOps.

For example, when you run Get-ADOAgentPool, it will add two properties to the return value:
PoolID (an alias to ID) and DateCreated (which converts the string date in .CreatedOn to a [DateTime]).


#### Supporting -WhatIf and -Confirm

Most commands in PSDevOps that change system state SupportShouldProcess, and have the automatic parameters -WhatIf and -Confirm.

-Confirm works the same in PSDevOps as it does in any PowerShell module.  Passing -Confirm will always prompt for confirmation, and Passing -Confirm:$false will never prompt for confirmation.

PSDevOps does a bit better than most modules when it comes to supporting -WhatIf.  In most modules, -WhatIf will write a message to the host about what might have run.  In PSDevOps, passing -WhatIf should return the values about to be passed to the REST API.

~~~PowerShell
New-ADOProject -Name Foo -Description bar -Confirm # Prompts for confirmation

New-ADOProject -Name Foo -Description bar -WhatIf  # Returns the data that would be passed to the REST endpoint. 
~~~  

### Creating Complex Pipelines

While Azure DevOps templates are nice, they don't give you syntax highlighting for the scripts of each step.  
Also, cross-repository templates can be painful.

PSDevOps allows you to create Azure DevOps pipelines using New-ADOPipeline.  

For instance, this create a cross-platform test of the current repository's PowerShell module.

~~~PowerShell
New-ADOPipeline -Job TestPowerShellOnLinux, TestPowerShellOnMac, TestPowerShellOnWindows
~~~

This creates a multistage pipeline that does PowerShell static analysis, tests the current module (crosssplatform),
and updates the PowerShell gallery using a Secret: 

~~~PowerShell
New-ADOPipeline -Stage PowerShellStaticAnalysis, TestPowerShellCrossPlatform, UpdatePowerShellGallery
~~~

This little one liner works wonderfully to build a CI/CD pipeline in Azure DevOps around almost any PowerShell modules.

Parts are stored in a \ado\PartName\ as either a .ps1 or a .psd1 file.
PS1 files will implicitly become script tasks.
PSD1 files will be treated as task metadata, and can reference other parts.

Any module that contains an \ADO directory and is tagged 'PSDevOps' or requires PSDevOps can contain parts.
Parts found in these modules will override parts found in PSDevOps.

#### Advanced Azure DevOps Pipeline Logging

PSDevOps can also be used to help you write information to the a pipeline's timeline.  This can be considerably easier than memorizing the [Logging Commands Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands).

PSDevOps makes this much nicer by abstracting away this ugliness into easy-to-use commands:

* Add-ADOAttachment
* Set-ADOBuild
* Set-ADOEndpoint
* Set-ADOVariable
* Write-ADOError
* Write-ADOProgress
* Write-ADOWarning


### Write GitHub Workflows

You can use PSDevOps to write complex Github Workflows using the same techniques as Azure DevOps pipelines:

~~~PowerShell
New-GitHubWorkflow -Name RunPester -On Demand, Push, PullRequest -Job TestPowerShellOnLinux
~~~  

As with Azure DevOps, parts of the workflow can be defined within the \GitHub subdirectory of PSDevOps or any module.

#### Advanced GitHub Workflow Logging

PSDevOps also includes commands to make logging within a GitHub workflow easier.  They are:

* Hide-GitHubOutput
* Write-GitHubDebug
* Write-GitHubError
* Write-GitHubOutput
* Write-GitHubWarning