
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



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |1      |true (ByPropertyName)|
---
#### **ScriptPath**

One or more paths to scripts.
If these paths resolve to directories, all files that match \.(?<Type>.+)\.ps1$
If the paths resolve to scripts or commands



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |2      |true (ByPropertyName)|
---
#### **ModuleInfo**

One or more modules.  This can be passed via the pipeline, for example:
Get-Module PSDevOps | Get-PSDevOps



|Type                  |Requried|Postion|PipelineInput                 |
|----------------------|--------|-------|------------------------------|
|```[PSModuleInfo[]]```|false   |3      |true (ByValue, ByPropertyName)|
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



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |4      |false        |
---
#### **Recurse**

If set, will search directories recursively.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Syntax
```PowerShell
Get-PSDevOps [[-Name] <String>] [[-ScriptPath] <String[]>] [[-ModuleInfo] <PSModuleInfo[]>] [[-Pattern] <String>] [-Recurse] [<CommonParameters>]
```
---


