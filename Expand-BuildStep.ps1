function Expand-BuildStep
{
    <#
    .Synopsis
        Expands Build Steps in a single build object
    .Description
        Component Files are .ps1 or datafiles within a directory that tells you what type they are.
    .Example
        Expand-BuildStep -StepMap @{Steps='InstallPester','RunPester'}
    .Link
        Convert-BuildStep
    .Link
        Import-BuildStep
    #>
    param(
    # A map of step properties to underlying data.
    # Each key is the name of a property the output.
    # Each value may contain the name of another Step or StepMap
    [Parameter(Mandatory)]
    [Collections.IDictionary]
    $StepMap,

    # The immediate parent object
    [PSObject]
    $Parent,

    # The absolute root object
    [PSObject]
    $Root,

    # If set, the component will be expanded as a singleton (single object)
    [switch]
    $Singleton,

    # A list of item names that automatically become singletons
    [string[]]$SingleItemName,

    # A list of item names that automatically become plurals
    [string[]]$PluralItemName,

    [ValidateSet('ADO', 'GitHubActions')]
    [string]$BuildSystem = 'ADO',

    # The name of parameters that should be supplied from build variables.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $VariableParameter,

    # The name of parameters that should be supplied from the environment.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $EnvironmentParameter,

    # The name of parameters that should be referred to uniquely.
    # For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
    # The build parameter would be foo_bar.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $UniqueParameter,

    # A collection of default parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $DefaultParameter = @{}
    )

    begin {
        $convertBuildStepCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Convert-BuildStep','Function')

    }

    process {

        $theComponentMetaData = $ComponentMetaData.$BuildSystem
        $theComponentNames = $ComponentNames.$BuildSystem

        $outObject = [Ordered]@{}
        $splatMe = @{} + $PSBoundParameters
        if (-not $Root) {
            $Root = $outObject
            $splatMe.Root = $outObject
        }

        $splatMe.Remove('StepMap')
        :nextKey foreach ($kv in $stepMap.GetEnumerator()) {
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

                if ($propName -eq $thingType -and -not $singleton) {
                    if ($v -is [Collections.IDictionary]) {
                        $splatMe.StepMap = $v
                        Expand-BuildStep @splatMe
                    } else {
                        $v
                    }

                    continue nextValue
                }


                $o =
                    if ($metaData.Extension -eq '.psd1') {

                        $data = Import-LocalizedData -BaseDirectory ([IO.Path]::GetDirectoryName($metaData.Path)) -FileName ([IO.PATH]::GetFileName($metaData.Path))
                        if (-not $data) {
                            continue nextValue
                        }
                        $fileText = [IO.File]::ReadAllText($metaData.Path)
                        $data = & ([ScriptBlock]::Create(($FileText -replace '@{', '[Ordered]@{')))
                        $splatMe.Parent = $stepMap
                        if ($data -is [Collections.IDictionary]) {
                            $splatMe.StepMap = $data
                            try { Expand-BuildStep @splatMe }
                            catch {
                                Write-Debug "Could not Expand $($kv.Id): $_"
                            }
                        } else {
                            $data
                        }
                    }
                    elseif ($v -is [Collections.IDictionary])
                    {
                        $splatMe.Parent = $stepMap
                        $splatMe.StepMap = $v
                        Expand-BuildStep @splatMe
                    } else
                    {
                        $convertedBuildStep =
                            if ($metaData) {
                                $convertSplat = @{} + $PsBoundParameters
                                foreach ($k in @($convertSplat.Keys)) {
                                    if (-not $convertBuildStepCmd.Parameters[$k]) {
                                        $convertSplat.Remove($k)
                                    }
                                }
                                $metaData |
                                    Convert-BuildStep @convertSplat
                            }

                        if ($convertedBuildStep) {
                            if ($convertedBuildStep.parameters) {
                                if ($BuildSystem -eq 'ADO' -and $Root) {
                                    
                                    $root.parameters = 
                                        if ($root.parameters) {
                                            $root.parameters += @($convertedBuildStep.parameters) 
                                            $root.parameters = @($root.parameters| 
                                                Select-Object -Unique)

                                        } else {
                                            @($root.parameters)
                                        }
                                        
                                    $convertedBuildStep.Remove('parameters')
                                }
                            }
                            $convertedBuildStep
                        } else {
                            $v
                        }
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

            if ($PluralItemName -contains $propName -and 
                $outObject[$propName] -isnot [Collections.IList]) {
                $outObject[$propName] = @($outObject[$propName])
            }
        }
        $outObject

    }
}
