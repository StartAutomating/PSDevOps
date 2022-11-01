Get-PSDevOps
------------
### Synopsis
Gets PSDevOps commands.

---
### Description

Gets PSDevOps commands.

PSDevOps commands are self-contained scripts that complete end-to-end scenarios.

They are traditionally named with the patterns *.*.ps1 or *.*.*.ps1.
                     
For example: 
    *.psdevops.ps1 files are used to run commands in PSDevOps.  
    *.GitHubAction.PSDevOps.ps1 would indicate creating a GitHubAction.
    *.tests.ps1 files are used by Pester
    *.ezout|ezformat|format|view.ps1 files are used by EZOut
    
To name a few examples of where the technique is used.

Using Get-PSDevOps will return extended command information and addtional methods.

---
### Examples
#### EXAMPLE 1
```PowerShell
Get-PSDevOps # Get *.*.ps1 commands in the current directory
```

#### EXAMPLE 2
```PowerShell
Get-Module PSDevops | Get-PSDevOps # Gets related commands
```

---
### Parameters
#### **Name**

The name of the script.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **ScriptPath**

One or more paths to scripts.
If these paths resolve to directories, all files that match \.(?<Type>.+)\.ps1$
If the paths resolve to scripts or commands



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **ModuleInfo**

One or more modules.  This can be passed via the pipeline, for example:
Get-Module PSDevOps | Get-PSDevOps



> **Type**: ```[PSModuleInfo[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByValue, ByPropertyName)



---
#### **Pattern**

The Regular Expression Pattern used to search for files.
If a -Pattern is provided, named capture groups in that pattern will become noteproperties of the output object.
By default:
    (?<ScriptSubtype>\.\w+.)?\.(?<ScriptType>\w+)\.ps1$
    This roughly translates as:
       Any *.*.ps1 file
       The Named Capture 'Type' the type of .ps1
       The Optional Named Capture, Subtype, will match an additional '.Something'



> **Type**: ```[String]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **Recurse**

If set, will search directories recursively.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Get-PSDevOps [[-Name] <String>] [[-ScriptPath] <String[]>] [[-ModuleInfo] <PSModuleInfo[]>] [[-Pattern] <String>] [-Recurse] [<CommonParameters>]
```
---
