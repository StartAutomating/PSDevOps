<#
.Synopsis
    Expands Component Files into one Object
.Description
    Component Files are .ps1 or datafiles within a directory that tells you what type they are.

#>
param(
# A table of data that could contain components.
[Parameter(Mandatory)]
[Collections.IDictionary]
$PartTable,
# The parent object
$Parent, 
# If set, the component will be expanded as a singleton (single object)
[switch]$Singleton,
# A list of item names that automatically become singletons 
[string[]]$SingleItemName,
# The type of component, currently, ADO or GitHubActions.  
[ValidateSet('ADO','GitHubActions')]
[string]$ComponentType
)

$theComponentMetaData = $ComponentMetaData.$ComponentType
$theComponentNames = $ComponentNames.$ComponentType

$outObject = [Ordered]@{}
$splatMe = @{} + $PSBoundParameters
$splatMe.Remove('PartTable')
:nextKey foreach ($kv in $PartTable.GetEnumerator()) {
    if ($kv.Key.EndsWith('s') -and -not $singleton) { # Already pluralized
        $thingType = $kv.Key.Substring(0,$kv.Key.Length -1)
        $propName = $kv.Key
    } elseif ($parent) {
        $thingType = $kv.Key
        $propName = $kv.Key
    } else {
        $thingType = $kv.Key
        $propName =
            if ($SingleItemName -notcontains $thingType -and 
                $thingType -notmatch '\W$' -and
                $theComponentNames.Keys -contains $thingType) {
                $kv.Key.Substring(0,1).ToLower() + $kv.Key.Substring(1) + 's'
            } else {
                $kv.Key.Substring(0,1).ToLower() + $kv.Key.Substring(1)
                $singleton = $true
            }
    }
    $outValue = :nextValue foreach ($v in $kv.Value) {
        $metaData = $theComponentMetaData["$thingType.$v"]
        $ft = if ($metaData.Path) { [IO.File]::ReadAllText($metaData.Path) }
        if ($propName -eq $thingType -and -not $singleton) {
            if ($v -is [Collections.IDictionary]) {
                $splatMe.PartTable = $v
                & $ExpandComponents @splatMe
            } else {
                $v
            }
            
            continue nextValue
        }


        $o =
            if ($metaData.Extension -eq '.ps1') {
                $sb = [ScriptBlock]::Create($ft)
                if (-not $sb) { continue }
                $out = [Ordered]@{}
                if ($ComponentType -eq 'ADO') {
                    if ($outObject.pool -and $outObject.pool.vmimage -notlike '*win*') {
                        $out.pwsh = "$sb"
                    } else {
                        $out.powershell = "$sb"
                    }
                    $out.displayName = $metaData.Name
                
                    if ($UseSystemAccessToken) {
                        $out.env = @{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}
                    }
                } elseif ($ComponentType -eq 'GitHubActions') {
                    $out.name = $metaData.Name
                    $out.runs = "$sb"   
                    $out.shell = 'pwsh'
                }
                $out
            }
            elseif ($metaData.Extension -eq '.psd1') {
                $data = Import-LocalizedData -BaseDirectory ([IO.Path]::GetDirectoryName($metaData.Path)) -FileName ([IO.PATH]::GetFileName($metaData.Path))
                if (-not $data) {
                    continue nextValue
                }
                $data = & ([ScriptBlock]::Create(($ft -replace '@{', '[Ordered]@{')))
                $splatMe.Parent = $PartTable
                if ($data -is [Collections.IDictionary]) {
                    $splatMe.PartTable = $data
                    try { & $ExpandComponents @splatMe }
                    catch { 
                        Write-Debug "Could not Expand $($kv.Id): $_"
                    }
                } else {
                    $data
                }
            }
            elseif ($metaData.Extension -eq '.sh') {
                $out = [Ordered]@{bash="$ft";displayName=$metaData.Name}
                $out
            }
            elseif ($v -is [Collections.IDictionary]) {
                $splatMe.Parent = $PartTable
                $splatMe.PartTable = $v 
                & $ExpandComponents @splatMe
            } else {
                $v
            }


        if ($metaData.Name -and $Option.$($metaData.Name) -is [Collections.IDictionary]) {
            $o2 = [Ordered]@{} + $o
            foreach ($ov in @($Option.($metaData.Name).GetEnumerator())) {
                $o2[$ov.Key] = $ov.Value
            }
            $o2
        } else {
            $o
        }
    }

    $outObject[$propName] = $outValue


    if ($outObject[$propName] -isnot [Collections.IList] -and 
        $kv.Value -is [Collections.IList] -and -not $singleton) {
        $outObject[$propName] = @($outObject[$propName])
    } elseif ($outObject[$propName] -is [Collections.IList] -and $kv.Value -isnot [Collections.IList]) {
        $outObject[$propName] = $outObject[$propName][0]
    }
}
$outObject
