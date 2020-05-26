### PSDevOps is a collection of PowerShell tools for DevOps.


Using PSDevOps, you can:

* Elegantly Create Azure DevOps pipelines
* Invoke Azure DevOps REST APIs
* Simplify Azure DevOps logging

### Elegantly Create Azure DevOps Pipelines

While Azure DevOps templates are nice, they don't give you syntax highlighting for the scripts of each step.  Also, cross-repository templates are painful.

PSDevOps allows you to create Azure DevOps pipelines New-ADOPipeline.  For instance, this create a cross-platform test of the current repository's PowerShell module.

    New-ADOPipeline -Job TestPowerShellOnLinux, TestPowerShellOnMac, TestPowerShellOnWindows


This creates a multistage pipeline that tests the current module crosssplatform, and updates the PowerShell gallery using a Secret: 


    New-ADOPipeline -Stage TestPowerShellCrossPlatform, UpdatePowerShellGallery


Parts are stored in a \ado\PartName\ as either a .ps1 or a .psd1 file.
PS1 files will implicitly become script tasks.
PSD1 files will be treated as task metadata, and can reference other parts.

Any module that contains an \ADO directory and is tagged 'PSDevOps' or requires PSDevOps can contain parts.
Parts found in these modules will override parts found in PSDevOps.


### Simplify Azure DevOps Logging

If you've ever visited the [Logging Commands Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands), you might have noticed just how ugly the console logging of Azure DevOps is.  

TL;DR, everything is prefixed by ##vso[ , and some complicated setting arguments.

PSDevOps makes this much nicer by abstracting away this ugliness into easy-to-use commands:

* Add-ADOAttachment
* Set-ADOBuild
* Set-ADOEndpoint
* Set-ADOVariable
* Write-ADOError
* Write-ADOProgress
* Write-ADOWarning
