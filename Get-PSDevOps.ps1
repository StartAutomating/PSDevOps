function Get-PSDevOps
{
    <#
    .Synopsis
        Gets PSDevOps commands.    
    .Description
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
    .Example
        Get-PSDevOps # Get *.*.ps1 commands in the current directory
    .Example
        Get-Module PSDevops | Get-PSDevOps # Gets related commands
    #>
    param(
    # The name of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # One or more paths to scripts.
    # If these paths resolve to directories, all files that match \.(?<Type>.+)\.ps1$
    # If the paths resolve to scripts or commands
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string[]]
    $ScriptPath,

    # One or more modules.  This can be passed via the pipeline, for example:
    # Get-Module PSDevOps | Get-PSDevOps
    [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [PSModuleInfo[]]
    $ModuleInfo,

    # The Regular Expression Pattern used to search for files.
    # If a -Pattern is provided, named capture groups in that pattern will become noteproperties of the output object.
    # By default:
    #     (?<ScriptSubtype>\.\w+.)?\.(?<ScriptType>\w+)\.ps1$
    #     This roughly translates as:
    #        Any *.*.ps1 file
    #        The Named Capture 'Type' the type of .ps1
    #        The Optional Named Capture, Subtype, will match an additional '.Something'
    [string]
    $Pattern = "(?<ScriptSubtype>\.\w+.)?\.(?<ScriptType>\w+)\.ps1$",

    # If set, will search directories recursively.
    [switch]
    $Recurse
    )

    begin {
        $regexPattern = [Regex]::new($Pattern, 'IgnoreCase,IgnorePatternWhitespace')
        $myModuleName = $MyInvocation.MyCommand.Module.Name
        if (-not $script:KnownDevOpsScriptTypes) {
            $script:KnownDevOpsScriptTypes = @{}
            foreach ($loadedModule in Get-Module) {
                $moduleData = $loadedModule.PrivateData.$myModuleName
                if (-not $moduleData) { continue }
                if ($moduleData.ScriptType -isnot [Hashtable]) { continue }
                foreach ($kv in $moduleData.ScriptType.GetEnumerator()) {                    
                    $script:KnownDevOpsScriptTypes[$kv.Key] = $kv.Value
                }
            }
        }               
    }

    process {
        $MyModuleName = $MyInvocation.MyCommand.Module.Name
        if (-not $ModuleInfo -and -not $ScriptPath) {  
            $ModuleInfo = 
                @(foreach ($mod in Get-Module) {
                    if ($MyModuleName -and (
                        ($mod.PrivateData.PSData.Tags -contains $MyModuleName) -or 
                        $mod.PrivateData.$MyModuleName
                    )) {
                        $mod
                    }
                })
        }
                
        if ($ModuleInfo) {
            $ScriptPath += try { $ModuleInfo | Split-Path -ErrorAction SilentlyContinue } catch { Write-Verbose "Could not Split-Path for $($ModuleInfo)"  }
        }
        if (-not $ScriptPath) { $ScriptPath += "$pwd" }
        $ScriptPath = $ScriptPath | Select-Object -Unique
        foreach ($sp in $ScriptPath) {
            $resolvedPath =
                if ([IO.File]::Exists($sp)) {
                    $sp
                } else {
                    $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($sp) # Resolve the path
                }
                
            if (-not $resolvedPath) { continue }    # ( if we couldn't, keep moving).
            # Since the path exists, it's either a file or a directory.
            if ([IO.File]::Exists($resolvedPath)) { # If it's a file
                $resolvedPathCmd = # get it as a command,
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand("$resolvedPath", 'All')
                $resolvedPathCmd.pstypenames.clear()
                $resolvedPathCmd.pstypenames.add('PSDevOps') # then decorate that command as 'PSDevOps',
                $resolvedPathCmd # output,
                continue # and continue.
            }

            # If it's a directory, recurse matters.  Also, .NET will be faster than PowerShell providers
            $dir = [IO.DirectoryInfo]"$resolvedPath"
            foreach ($fsi in $dir.GetFileSystemInfos("*", [IO.SearchOption][int][bool]$Recurse)) {
                $matched = $regexPattern.Match($fsi.Name)
                if (-not $matched.Success) { continue }
                $resolvedPathCmd = # get it as a command,
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($fsi.fullname, 'All')
                $resolvedPathCmd.pstypenames.clear()
                $resolvedPathCmd.pstypenames.add('PSDevOps') # then decorate that command as 'PSDevOps',
                $resolvedPathCmd.pstypenames.add('PSDevOps.Script')

                foreach ($group in $matched.Groups[1..$($matched.Groups.Count -1)]) {
                    $resolvedPathCmd.psobject.properties.add([PSNoteProperty]::new($group.Name, $group.Value))
                }

                
                if ($resolvedPathCmd.ScriptType) {
                     $resolvedPathCmd.psobject.properties.add(
                        [PSNoteProperty]::new("ScriptTypeDescription", 
                            $script:KnownDevOpsScriptTypes[$resolvedPathCmd.ScriptType]
                        ))                     
                }
                
                $resolvedPathCmd
            }
        }
    }
}
