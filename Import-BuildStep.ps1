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
    [ValidateSet('ADOPipeline', 'GitHubWorkflow')]
    [string[]]
    $BuildSystem = @('ADOPipeline', 'GitHubWorkflow'),

    # A list of valid directory aliases for a given build system.
    # By default, ADOPipelines can exist within a directory named ADOPipeline, ADO, AzDO, or AzureDevOps.
    # By default, GitHubWorkflows can exist within a directory named GitHubWorkflow, GitHubWorkflows, or GitHub.
    [Alias('BuildSystemAliases')]
    [Collections.IDictionary]
    $BuildSystemAlias = $(@{
        ADOPipeline = 'ADO', 'AzDO', 'AzureDevOps'
        GitHubWorkflow = 'GitHub', 'GitHubWorkflows'
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
                    foreach ($rbs in $resolvedBuildSystems) {
                        # for that build system.
                        Import-BuildStep -SourcePath $id.Fullname -BuildSystem $rbs
                    }
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
                # Then import the command into each build system as a 'Step'
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
                    $t = 'Step'
                    if (-not $ThingNames.ContainsKey($t)) {
                        $ThingNames[$t] = [Collections.Generic.List[string]]::new()
                    }
                    $n = $exCmd.Name
                    if (-not $ThingNames[$t].Contains($n)) {
                        $ThingNames[$t].Add($n)
                    }

                    $ThingData["$($t).$($n)"] = [PSCustomObject][Ordered]@{
                        Name      = $n
                        Type      = $t
                        ScriptBlock = $exCmd.ScriptBlock
                        Module    = $Module
                    }
                }
            }
            #endregion Import Module Commands
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'SourcePath') {
            # If we've been provided a -SourcePath, start by making sure we only have one -BuildSystem.
            if ($BuildSystem.Length -gt 1) {
                Write-Error "Can only import from a -SourcePath for one -BuildSystem at a time."
                return
            }
            $bs = $BuildSystem[0]
            $sourceItem = Get-Item $SourcePath
            if ($sourceItem -isnot [IO.DirectoryInfo]) { # If the source path isn't a directory, error out.
                Write-Error "-SourcePath must be a directory."
                return
            }
            if ($sourceItem.Name -ne $bs -and
                $sourceItem.Name -notin $BuildSystemAlias[$bs]) {
                # If the source path wasn't a _valid_ directory name, error out.
                Write-Error (@(
                    "-SourcePath must match -BuildSystem '$BuildSystem'.
                    Must be '$BuildSystem' or '$($BuildSystemAlias[$bs] -join "','")'"
                ) -join ([Environment]::NewLine))
                return
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

            # Get all of the files beneath this point
            $fileList = Get-ChildItem -Filter * -Recurse -LiteralPath $sourceItem.FullName
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

                # Make a collection of metadata for the thing, and store it by it's disambiguated name.
                $ThingData["$($t).$($n)"] = [PSCustomObject][Ordered]@{
                    Name      = $n
                    Type      = $t
                    Extension = $f.Extension
                    Path      = $f.FullName
                }
            }
            #endregion Import Files for a BuildSystem
        }

    }
}