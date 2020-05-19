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
    param(
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Name')]
    [string]
    $ModuleName,

    # A list of commands to exclude
    [string[]]
    $ExcludeCommand,

    [ValidateSet('ADO', 'GitHubActions')]
    [string[]]
    $BuildSystem = @('ado', 'githubactions')
    )

    begin {
        if (-not $script:ComponentMetaData) {
            $script:ComponentMetaData = [Collections.Generic.Dictionary[
                string,
                Collections.Generic.Dictionary[string,PSObject]
            ]]::new([StringComparer]::OrdinalIgnoreCase)
        }

        if (-not $script:ComponentNames) {
            $script:ComponentNames = [Collections.Generic.Dictionary[
                string,
                Collections.Generic.Dictionary[
                    string,
                    Collections.Generic.List[string]
                ]
            ]]::new([StringComparer]::OrdinalIgnoreCase)
        }
    }
    process {
        $module = if ($_ -is [Management.Automation.PSModuleInfo]) {
            $_
        } else {
            Get-Module $ModuleName | Select-Object -First 1
        }
        if (-not $module) { return }
        $d = [IO.DirectoryInfo][IO.Path]::GetDirectoryName($Module.Path)
        foreach ($id in $d.GetDirectories()) {
            $componentTypeName = $id.Name
            if ($BuildSystem -notcontains $id.Name) { continue }
            if (-not $script:ComponentNames.ContainsKey($componentTypeName)) {
                $script:ComponentNames[$componentTypeName] =
                    [Collections.Generic.Dictionary[
                        string,
                        Collections.Generic.List[string]
                    ]]::new([StringComparer]::OrdinalIgnoreCase)

                $script:ComponentMetaData[$componentTypeName] =
                    [Collections.Generic.Dictionary[string,PSObject]]::new([StringComparer]::OrdinalIgnoreCase)
            }


            $fileList = Get-ChildItem -Filter * -Recurse -Path $id.FullName
            $ThingNames = $script:ComponentNames[   $componentTypeName]
            $ThingData  = $script:ComponentMetaData[$componentTypeName]
            foreach ($f in $fileList) {
                if ($f.Directory -eq $rootDir) { continue }
                if ($f -is [IO.DirectoryInfo]) { continue }
                $n = $f.Name.Substring(0, $f.Name.Length - $f.Extension.Length)
                $t = $f.Directory.Name.TrimEnd('s')
                if (-not $ThingNames.ContainsKey($t)) {
                    $ThingNames[$t] = [Collections.Generic.List[string]]::new()
                }
                if (-not $ThingNames[$t].Contains($n)) {
                    $ThingNames[$t].Add($n)
                }

                $ThingData["$($t).$($n)"] = [PSCustomObject][Ordered]@{
                    Name      = $n
                    Type      = $t
                    Extension = $f.Extension
                    Path      = $f.FullName
                }
            }
        }

        :nextCmd foreach ($exCmd in $Module.ExportedCommands.Values) {
            foreach ($exclusion in $ExcludeCommand) {
                if ($exCmd -like $exclusion) {
                    continue nextCmd
                }
            }
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
                if (-not $ThingNames[$t].Contains($n)) {
                    $ThingNames[$t].Add($n)
                }

                $n = $exCmd.Name
                $ThingData["$($t).$($n)"] = [PSCustomObject][Ordered]@{
                    Name      = $n
                    Type      = $t
                    ScriptBlock = $exCmd.ScriptBlock
                    Module    = $Module
                }
            }

        }
    }
}