<div align='center'>
<img src='Assets/PSDevOps.svg' />
</div>

PowerShell Tools for DevOps
---------------------------
[![Gallery Downloads](https://img.shields.io/powershellgallery/dt/PSDevOps)](https://www.powershellgallery.com/packages/PSDevOps/)
[![Build Status](https://dev.azure.com/StartAutomating/PSDevOps/_apis/build/status/StartAutomating.PSDevOps?branchName=master)](https://dev.azure.com/StartAutomating/PSDevOps/_build/latest?definitionId=5)
[![Build Status](https://github.com/StartAutomating/Irregular/actions/workflows/IrregularTests.yml/badge.svg)](https://github.com/StartAutomating/PSDevOps/actions/workflows/TestAndPublish.yml)
---------------------------

__PSDevOps helps you automate DevOps using PowerShell.__

### What is PSDevOps?

PSDevOps is a PowerShell module that makes it easier to automate DevOps with PowerShell.

* [Automate Azure DevOps](#Automate-Azure-DevOps)
* [Creating Complex Pipelines](#Creating-Complex-Pipelines)
* [Dealing with DevOps](#Dealing-with-DevOps)
* [Get the GitHub API](#PSDevOps-GitHub-API)
* [Write GitHub Actions](#Write-GitHub-Actions)
* [Write GitHub Workflows](#Write-GitHub-Workflows)

#### What do you mean 'Easier to Automate'?

If you're familiar with PowerShell, you might know about the Object Pipeline.  
This allows you to pass objects together, instead of parsing text at each step.
While this is great, not many PowerShell commands or REST apis take full advantage of this feature.

PSDevOps does.

Almost every command in PSDevOps is pipeline-aware.  
Related commands can often be piped together, and command results can often be piped back into a command to return additional information.

Additionally, PSDevOps output is often 'decorated' with extended type information.

This allows the PowerShell types and formatting engine to extend the return object and customize it's display.

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


#### Invoke-ADORESTApi

In orer to ensure that you can always work with Azure DevOps, even if there isn't already a function in PSDevOps, there's Invoke-ADORestAPI.

Invoke-ADORestAPI can be used like Invoke-RESTMethod, and also has a number of additional features.

For instance:

* -AsJob (Launch long-running queries as a job)
* -Body (autoconverted to JSON)
* -ExpandProperty (Expand out a particular property from output)
* -PSTypeName (apply decoration to output)
* -UrlParameter (Replace parameters within a URL)
* -QueryParameter (Pass parameters within a querystring)

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


### Dealing with DevOps


DevOps is a hybrid discipline combining the skillset of Devolopers and Operations.  
With DevOps, the focus is on automation, and PowerShell is often the language of choice.

By convention, most developers write their scripts according to a psuedostandard:

> ```*-*.ps1``` Scripts containing a function  
> ```*.*.ps1``` 'Special' Scripts, often used by particular modules
> ```*.ps1``` Simple scripts that are run interactively.


PSDevOps has a command, Get-PSDevOps, that helps to identify these scripts and their requirements.

~~~PowerShell
Get-Module PSDevOps | Get-PSDevOps
~~~


### PSDevOps GitHub API

PSDevOps also provides a few functions to work with the GitHub API.

* Connect/Disconnect-GitHub
* Invoke-GitHubRESTAPI

Invoke-GitHubRESTAPI works like Invoke-ADORestAPI, as a general-purpose wrapper for GitHub REST API calls.

It also has a number of additional features, for example:

* -AsJob (Launch long-running queries as a job)
* -Body (autoconverted to JSON)
* -ExpandProperty (Expand out a particular property from output)
* -PSTypeName (apply decoration to output)
* -UrlParameter (Replace parameters within a URL)
* -QueryParameter (Pass parameters within a querystring)

Because GitHub's REST api is predictable and exposed with OpenAPI, Invoke-GitHubRESTAPI also enables two very interesting scenarios:

1. Connect-GitHub can automatically create a shortcut for every endpoint in the GitHub API
2. Invoke-GitHubRESTAPI can automatically decorate return values more apporopriately.

This means that PSDevOps can integrate with GitHub's REST API with a very small amount of code, and easily customize how GitHub output displays and works in PowerShell.

### Write GitHub Actions

You can automatically generate GitHub actions off of any PowerShell script or command.

First, create a /GitHub/Actions folder in your module directory, then put one or more .ps1 files in it.

Then, 
~~~PowerShell
Import-BuildStep -ModuleName YourModule
~~~

Then, you can generate your action.yml with some code like this.

~~~PowerShell
New-GitHubAction -Name "Name Of Action" -Description 'Action Description' -Action MyAction -Icon minimize -ActionOutput ([Ordered]@{
    SomeOutput = [Ordered]@{
        description = "Some Output"
        value = '${{steps.MyAction.outputs.SomeOutput}}'
    }    
})
~~~

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