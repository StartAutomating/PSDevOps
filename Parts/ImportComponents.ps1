param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [Management.Automation.PSModuleInfo]
    $Module,
    
    [Parameter(Mandatory,Position=0)]
    [string[]]
    $ComponentRoot
)
process {
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

    $d = [IO.DirectoryInfo][IO.Path]::GetDirectoryName($Module.Path)
    foreach ($id in $d.GetDirectories()) {
        $componentTypeName = $id.Name
        if ($ComponentRoot -notcontains $id.Name) { continue }
        if (-not $ComponentNames.ContainsKey($componentTypeName)) {
            $ComponentNames[$componentTypeName] = 
                [Collections.Generic.Dictionary[
                    string,
                    Collections.Generic.List[string]
                ]]::new([StringComparer]::OrdinalIgnoreCase)
        
            $ComponentMetaData[$componentTypeName] = 
                [Collections.Generic.Dictionary[string,PSObject]]::new([StringComparer]::OrdinalIgnoreCase)
        }
        
        
        $fileList = Get-ChildItem -Filter * -Recurse -Path $id.FullName
        $ThingNames = $ComponentNames[   $componentTypeName]
        $ThingData  = $ComponentMetaData[$componentTypeName]
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
}