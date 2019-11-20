function New-ADOPipeline
{
    <#
    .Synopsis
        Creates a new ADO Pipeline
    .Description
        Create a new Azure DevOps Pipeline.
    .Example
        New-ADOPipeline -Stage TestPowerShellCrossPlatForm, UpdatePowerShellGallery
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for null (0 is ok)")]
    param()

    dynamicParam {
        $newDynamicParameter = {
            param([string]$name, [string[]]$ValidSet, [type]$type = [string],[string]$ParameterSet = '__AllParameterSets', [switch]$Mandatory)

            $ParamAttr = [Management.Automation.ParameterAttribute]::new()
            $ParamAttr.Mandatory = $Mandatory
            $ParamAttr.ParameterSetName = $ParameterSet

            $ParamAttributes = [Collections.ObjectModel.Collection[System.Attribute]]::new()
            $ParamAttributes.Add($ParamAttr)

            if ($ValidSet) {
                $ParamAttributes.Add([Management.Automation.ValidateSetAttribute]::new($ValidSet))
            }

            [Management.Automation.RuntimeDefinedParameter]::new($name,  $type, $ParamAttributes)
        }

        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

        if ($script:ThingNames) {
            foreach ($kv in $script:ThingNames.GetEnumerator()) {
                $k = $kv.Key.Substring(0,1).ToUpper() + $kv.Key.Substring(1)
                $DynamicParameters.Add($k, $(& $newDynamicParameter $k $kv.Value ([string[]])))
            }
        }
        return $DynamicParameters
    }

    begin {
        $joinPipelineParts = {
            param([Collections.IDictionary]$partTable, $Parent, [switch]$Singleton)

            $outObject = [Ordered]@{}
            foreach ($kv in $partTable.GetEnumerator()) {
                if ($kv.Key.EndsWith('s') -and -not $singleton) { # Already pluralized
                    $thingType = $kv.Key.Substring(0,$kv.Key.Length -1)
                    $propName = $kv.Key
                } elseif ($parent) {
                    $thingType = $kv.Key
                    $propName = $kv.Key
                } else {
                    $thingType = $kv.Key
                    $propName =
                        if ('trigger' -notcontains $thingType) {
                            $kv.Key.Substring(0,1).ToLower() + $kv.Key.Substring(1) + 's'
                        } else {
                            $kv.Key.Substring(0,1).ToLower() + $kv.Key.Substring(1)
                            $singleton = $true
                        }
                }
                $outObject[$propName] = foreach ($v in $kv.Value) {
                    $md = $script:ThingData["$thingType.$v"]
                    $ft = if ($md.Path) { [IO.File]::ReadAllText($md.Path) }
                    if ($propName -eq $thingType -and -not $singleton) {
                        $kv.Value; continue
                    }
                    if ($md.Extension -eq '.ps1') {
                        $sb = [ScriptBlock]::Create($ft)
                        if (-not $sb) { continue }
                        $out = [Ordered]@{}
                        if ($outObject.pool -and $outObject.pool.vmimage -notlike '*win*') {
                            $out.pwsh = "$sb"
                        } else {
                            $out.powershell = "$sb"
                        }
                        $out.displayName = $md.Name
                        $out
                    } elseif ($md.Extension -eq '.psd1') {
                        $data = Import-LocalizedData -BaseDirectory ([IO.Path]::GetDirectoryName($md.Path)) -FileName ([IO.PATH]::GetFileName($md.Path))
                        if (-not $data) {
                            continue
                        }
                        $htStart = $ft.IndexOf('@{')
                        if ($htStart -eq '-1') { continue }
                        $data = & ([ScriptBlock]::Create(($ft -replace '@{', '[Ordered]@{')))
                        & $joinPipelineParts $data -Parent $partTable -singleton:$Singleton

                    } elseif ($v -is [Collections.IDictionary]) {
                        & $joinPipelineParts $v -parent $partTable -singleton:$Singleton
                    } else {
                        $v
                    }
                }

                if ($outObject[$propName] -isnot [Collections.IList] -and $kv.Value -is [Collections.IList] -and -not $singleton) {
                    $outObject[$propName] = @($outObject[$propName])
                } elseif ($outObject[$propName] -is [Collections.IList] -and $kv.Value -isnot [Collections.IList]) {
                    $outObject[$propName] = $outObject[$propName][0]
                }
            }
            $outObject
        }

        $toYaml = {
            param(
            [Parameter(ValueFromPipeline,Position=0)]$Object,
            [Object]$Parent,
            [Object]$GrandParent,
            [int]$Indent = 0)

            begin { $n = 0; $mySelf = $myInvocation.MyCommand.ScriptBlock }
            process {
                $n++
                if ($Object -eq $null) { return }

                if ($Parent -and $Parent -is [Collections.IList]) {
                    if ($Parent.IndexOf($Object) -gt 0) { ' ' * $Indent }
                    '- '
                }

                #region Primitives
                if ( $Object -is [string] ) { # If it's a string
                    if ($object -match '\n') { # see if it's a multline string.
                        "|" # If it is, emit the multiline indicator
                        $indent+=2
                        foreach ($l in $object -split '(?>\r\n|\n)') { # and emit each line indented
                            [Environment]::NewLine
                            ' ' * $indent
                            $l
                        }
                        $indent-=2
                    } elseif ($object -match '\*') {
                        "`"$($Object -replace '\"','\')`""
                    } else {
                        $object
                    }

                    if ($Parent -is [Collections.IList]) { # If the parent object was a list
                        [Environment]::NewLine # emit a newline.
                    }
                    return # Once the string has been emitted, return.
                }
                if ( [int], [float], [bool] -contains $Object.GetType() ) { # If it is an [int] or [float] or [bool]
                    "$Object".ToLower()  # Emit it in lowercase.
                    if ($Parent -is [Collections.IList]) {
                        [Environment]::NewLine
                    }
                    return
                }
                #endregion Primitives

                #region KVP
                if ( $Object -is [Collections.DictionaryEntry] -or $object -is [Management.Automation.PSPropertyInfo]) {
                    if ($Parent -isnot [Collections.IList] -and
                        ($GrandParent -isnot [Collections.IList] -or $n -gt 1)) {
                        [Environment]::NewLine + (" " * $Indent)
                    }
                    if ($object.Key) {
                        $Object.Key +": "
                    } else {
                        $Object.Name +": "
                    }
                }

                if ( $Object -is [Collections.DictionaryEntry] -or $Object -is [Management.Automation.PSPropertyInfo]) {
                    & $mySelf -Object $Object.Value -Parent $Object -GrandParent $parent -Indent $Indent
                    return
                }
                #endregion KVP


                #region Nested
                if ($Object -is [Collections.IDictionary] -or $Object  -is [PSObject] -or $Object -is [Collections.IList]) {
                    $Indent += 2
                }


                if ( $Object -is [Collections.IDictionary] ) {
                    $Object.GetEnumerator() |
                        & $mySelf -Parent $Object -GrandParent $Parent -Indent $Indent
                } elseif ($Object -is [Collections.IList]) {

                    [Environment]::NewLine + (' ' * $Indent)

                    $Object |
                        & $mySelf -Parent $Object -GrandParent $Parent -Indent $Indent

                } elseif ($Object.PSObject.Properties) {
                    $Object.psobject.properties |
                        & $mySelf -Parent $Object -GrandParent $Parent -Indent $Indent
                }

                if ($Object -is [Collections.IDictionary] -or $Object  -is [PSCustomObject] -or $Object -is [Collections.IList]) {
                    if ($Parent -is [Collections.IList]) { [Environment]::NewLine }
                    $Indent -= 2;
                }
                #endregion Nested
            }
        }


    }

    process {
        $myParams = [Ordered]@{} + $PSBoundParameters
        $stepsByType = [Ordered]@{}
        foreach ($kv in $myParams.GetEnumerator()) {
            if ($script:ThingNames[$kv.Key]) {
                $stepsByType[$kv.Key] = $kv.Value
            }
        }

        $yamlToBe = & $joinPipelineParts $stepsByType

        @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
    }
}