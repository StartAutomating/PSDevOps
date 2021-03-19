function Import-BuildStep
{
    <#
    .Synopsis
        Imports Build Steps
    .Description
        Imports Build Steps defined in a module.
    .Example
        Import-BuildStep -ModuleName PSDevOps
    .Link
        Convert-BuildStep
    .Link
        Expand-BuildStep
    #>
    [OutputType([Nullable])]
    [CmdletBinding(DefaultParameterSetName='Module')]
    param(
    # The name of the module containing build steps.
    [Parameter(Mandatory,ParameterSetName='Module',ValueFromPipelineByPropertyName)]
    [Alias('Name')]
    [string]
    $ModuleName,

    # The source path.  This path contains definitions for a given single build system.
    [Parameter(Mandatory,ParameterSetName='SourcePath',ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $SourcePath,

    # A list of commands to include.
    [Parameter(ParameterSetName='Module',ValueFromPipelineByPropertyName)]
    [string[]]
    $IncludeCommand = '*',


    # A list of commands to exclude
    [Parameter(ParameterSetName='Module',ValueFromPipelineByPropertyName)]
    [string[]]
    $ExcludeCommand,

    # The different build systems supported.
    # Each buildsystem is the name of a subdirectory that can contain steps or other components.
    [ValidateSet('ADOPipeline', 'ADOExtension','GitHubAction','GitHubWorkflow')]
    [string[]]
    $BuildSystem = @('ADOPipeline', 'ADOExtension' ,'GitHubAction','GitHubWorkflow'),

    # A list of valid directory aliases for a given build system.
    # By default, ADOPipelines can exist within a directory named ADOPipeline, ADO, AzDO, or AzureDevOps.
    # By default, GitHubWorkflows can exist within a directory named GitHubWorkflow, GitHubWorkflows, or GitHub.
    [Alias('BuildSystemAliases')]
    [Collections.IDictionary]
    $BuildSystemAlias = $(@{
        ADOPipeline    = 'ADO', 'ADOPipelines', 'AzDO', 'AzDOPipelines', 'AzureDevOps', 'AzureDevopsPipelines'
        ADOExtension   = 'ADO', 'ADOExtensions', 'AzDO', 'AzDOExtensions','AzureDevOps', 'AzureDevOpsExtensions'
        GitHubWorkflow = 'GitHub', 'GitHubWorkflows'
        GitHubAction   = 'GitHub', 'GithubActions'
    }),

    [Alias('BuildSystemIncludes')]
    [Collections.IDictionary]
    $BuildSystemInclude = $(@{
        ADOPipeline    = '*'
        ADOExtension   = 'Contributions', 'Tasks'
        GitHubWorkflow = '*'
        GitHubAction   = 'Actions'
    }),

    [Alias('BuildCommandTypes')]
    [Collections.IDictionary]
    $BuildCommandType = $(@{
        ADOPipeline    = 'Step'
        ADOExtension   = 'Task'
        GitHubWorkflow = 'Step'
        GitHubAction   = 'Action'
    })
    )

    begin {
        # In order to generically import steps for any given buildstep,
        # we need two collection caches, and we need them to be fast.
        if (-not $script:ComponentMetaData) {
            # The ComponentMetaData maps the name of component
            # to the metadata extracted from a file or function.
            $script:ComponentMetaData = [Collections.Generic.Dictionary[
                string,
                Collections.Generic.Dictionary[string,PSObject]
            ]]::new([StringComparer]::OrdinalIgnoreCase)
            # For usability, this should be a case-insensitive map.
        }

        if (-not $script:ComponentNames) {
            # The Component names maps the name of each type of component (represented by a directory name)
            # to the full name in the component metadata.
            $script:ComponentNames = [Collections.Generic.Dictionary[
                string,
                Collections.Generic.Dictionary[
                    string,
                    Collections.Generic.List[string]
                ]
            ]]::new([StringComparer]::OrdinalIgnoreCase)
            # For usability, this should also be a case-insensitive map.
        }
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Module') {
            $module = # If the piped in object is a module,
                if ($_ -is [Management.Automation.PSModuleInfo]) {
                    $_ # use it directly.
                } else {
                    Get-Module $ModuleName |  # otherwise, get the loaded copies of the module
                        Select-Object -First 1 # and pick the first one.
                }
            if (-not $module) { return } # If we could not resolve the module, return.

            #region Import Module Files
            $d = [IO.DirectoryInfo][IO.Path]::GetDirectoryName($Module.Path) # Get the module root
            foreach ($id in $d.GetDirectories()) {
                $componentTypeName = $id.Name
                $resolvedBuildSystems = # Find any subdirectories that are named with a -BuildSystem
                    @(if ($BuildSystem -contains $id.Name) {
                        $id.Name
                    } else {
                        # Or named with a -BuildSystemAlias.
                        foreach ($kv in $BuildSystemAlias.GetEnumerator()) {
                            if ($kv.Value -contains $id.Name -and
                                $BuildSystem -contains $kv.Key) {
                                $kv.Key
                            }
                        }
                    })
                if ($resolvedBuildSystems) { # If any build systems resolved,
                    # Import steps from that directory
                    Import-BuildStep -SourcePath $id.Fullname -BuildSystem $resolvedBuildSystems                    
                }
            }
            #endregion Import Module Files

            #region Import Module Commands
            # Next walk over the list of exported commands
            :nextCmd foreach ($exCmd in $Module.ExportedCommands.Values) {
                $shouldInclude = $false
                # Check to see if each should be included.
                foreach ($Inclusion in $IncludeCommand) {
                    $shouldInclude = $exCmd -like $Inclusion
                    if ($shouldInclude) { break }
                }
                if (-not $shouldInclude)  { continue }
                # Then check to see if each should be excluded.
                foreach ($exclusion in $ExcludeCommand) {
                    if ($exCmd -like $exclusion) {
                        continue nextCmd
                    }
                }
                # Then import the command into each build system as whatever type of object it should be 
                # (for GitHubActions and ADOPipelines, 'Action' for GitHubActions, 'Task' for ADOExtensions)
                foreach ($componentTypeName in $BuildSystem) {
                    if (-not $script:ComponentNames.ContainsKey($componentTypeName)) {
                        $script:ComponentNames[$componentTypeName] =
                            [Collections.Generic.Dictionary[
                                string,
                                Collections.Generic.List[string]
                            ]]::new([StringComparer]::OrdinalIgnoreCase)

                        $script:ComponentMetaData[$componentTypeName] =
                            [Collections.Generic.Dictionary[string,PSObject]]::new([StringComparer]::OrdinalIgnoreCase)
                    }

                    $ThingNames = $ComponentNames[   $componentTypeName]
                    $ThingData  = $ComponentMetaData[$componentTypeName]
                    $t = $BuildCommandType[$componentTypeName]
                    if (-not $ThingNames.ContainsKey($t)) {
                        $ThingNames[$t] = [Collections.Generic.List[string]]::new()
                    }
                    $n = $exCmd.Name
                    if (-not $ThingNames[$t].Contains($n)) {
                        $ThingNames[$t].Add($n)
                    }

                    $stepData = [PSCustomObject][Ordered]@{
                        PSTypeName  = "PSDevOps.BuildStep"
                        Name        = $n
                        Type        = $t
                        ScriptBlock = $exCmd.ScriptBlock
                        Module      = $Module
                        BuildSystem = $componentTypeName
                    }
                    $stepData.pstypenames.add("PSDevOps.BuildStepCommand")
                    $stepData.pstypenames.add("PSDevOps.$bs.BuildStep")
                    $stepData.pstypenames.add("PSDevOps.$bs.BuildStepCommand")
                    $ThingData["$($t).$($n)"] = $stepData
                }
            }
            #endregion Import Module Commands
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'SourcePath') {
            

            $sourceItem = Get-Item $SourcePath
            if ($sourceItem -isnot [IO.DirectoryInfo]) { # If the source path isn't a directory, error out.
                Write-Error "-SourcePath must be a directory."
                return
            }
            # Get all of the files beneath this point
            $fileList = Get-ChildItem -Filter * -Recurse -LiteralPath $sourceItem.FullName

            foreach ($bs in $BuildSystem) {            
                
                if ($sourceItem.Name -ne $bs -and
                    $sourceItem.Name -notin $BuildSystemAlias[$bs]) {
                    # If the source path wasn't a _valid_ directory name, continue.
                    Write-Error (@(
                        "-SourcePath must match -BuildSystem '$BuildSystem'.
                        Must be '$BuildSystem' or '$($BuildSystemAlias[$bs] -join "','")'"
                    ) -join ([Environment]::NewLine))
                    continue
                }

            
                #region Import Files for a BuildSystem
                if (-not $script:ComponentNames.ContainsKey($bs)) { # Create a cash of data for this buildsystem
                    $script:ComponentNames[$bs] =
                        [Collections.Generic.Dictionary[
                            string,
                            Collections.Generic.List[string]
                        ]]::new([StringComparer]::OrdinalIgnoreCase)

                    $script:ComponentMetaData[$bs] =
                        [Collections.Generic.Dictionary[string,PSObject]]::new([StringComparer]::OrdinalIgnoreCase)
                }

                $ThingNames = $script:ComponentNames[   $bs]
                $ThingData  = $script:ComponentMetaData[$bs]
                foreach ($f in $fileList) {
                    if ($f.Directory -eq $rootDir) { continue } # Skip all files more than one level down.
                    if ($f -is [IO.DirectoryInfo]) { continue } # Skip all directories.
                    $n = $f.Name.Substring(0, $f.Name.Length - $f.Extension.Length)
                    $t = $f.Directory.Name.TrimEnd('s') # Depluralize the directory name.
                    if (-not $ThingNames.ContainsKey($t)) {
                        $ThingNames[$t] = [Collections.Generic.List[string]]::new()
                    }
                    if (-not $ThingNames[$t].Contains($n)) {
                        $ThingNames[$t].Add($n)
                    }

                    if ($BuildSystemInclude[$bs] -and 
                            ($n -notlike $BuildSystemInclude[$bs] -and 
                            $t -notlike $BuildSystemInclude[$bs])
                    ) {
                       continue 
                    }
                    

                    # Make a collection of metadata for the thing, and store it by it's disambiguated name.
                    $stepData = [PSCustomObject][Ordered]@{
                        PSTypeName  = "PSDevOps.BuildStep"
                        Name        = $n
                        Type        = $t
                        Extension   = $f.Extension
                        Path        = $f.FullName
                        BuildSystem = $bs
                    }
                    
                    $stepData.pstypenames.add("PSDevOps.$bs.BuildStep")
                    $ThingData["$($t).$($n)"] = $stepData
                }
                #endregion Import Files for a BuildSystem
            }
        }

    }
}