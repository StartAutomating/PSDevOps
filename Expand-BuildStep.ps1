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
    [OutputType([PSObject])]
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

    # A list of item names that automatically become dictionaries.
    [string[]]$DictionaryItemName,

    # The build system, either ADO or GitHub.
    [ValidateSet('ADOPipeline', 'ADOExtension','GitHubWorkflow','GitHubAction')]
    [string]$BuildSystem = 'ADOPipeline',

    # The name of parameters that should be supplied from build variables.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('VariableParameters')]
    [string[]]
    $VariableParameter,

    # The name of parameters that should be supplied from webhook events.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('InputParameters')]
    [Collections.IDictionary]
    $InputParameter,

    # The name of parameters that should be supplied from the environment.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('EnvironmentParameters')]
    [string[]]
    $EnvironmentParameter,

    # The name of parameters that should be referred to uniquely.
    # For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
    # The build parameter would be foo_bar.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('UniqueParameters')]
    [string[]]
    $UniqueParameter,

    # The name of parameters that should be excluded.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ExcludeParameters')]
    [string[]]
    $ExcludeParameter,

    # A collection of default parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $DefaultParameter = @{},

    # Options for the build system.  The can contain any additional parameters passed to the build system.
    [PSObject]
    $BuildOption
    )

    begin {
        $convertBuildStepCmd = # Get the command Convert-BuildStep, for we will need it later to splat.
            $ExecutionContext.SessionState.InvokeCommand.GetCommand('Convert-BuildStep','Function')
    }

    process {
        $theComponentMetaData = $script:ComponentMetaData.$BuildSystem
        $theComponentNames = $script:ComponentNames.$BuildSystem

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

            # Expand each value
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
                    #region Expand PSD1 Files
                    if ($metaData.Extension -eq '.psd1') {
                        $data =
                            Import-LocalizedData -BaseDirectory (
                                [IO.Path]::GetDirectoryName($metaData.Path)
                            ) -FileName (
                                [IO.PATH]::GetFileName($metaData.Path)
                            )
                        if (-not $data) { continue nextValue }
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
                    elseif ($metaData.Extension -eq '.json') {
                        [IO.File]::ReadAllText($metaData.Path) | ConvertFrom-Json                        
                    }
                    #endregion Expand PSD1 Files
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
                            if ($BuildSystem -eq 'ADOPipeline' -and
                                $Root -and
                                $convertedBuildStep.parameters) {


                                if ($root.parameters) {
                                    :nextKeyValue foreach ($keyValue in $convertedBuildStep.parameters) {
                                        foreach ($item in $root.Parameters) {
                                            if ($item.Name -eq $keyValue.Name) {
                                                if ($item.default -ne $keyValue.default) {
                                                    $item.default = ''
                                                }
                                                continue nextKeyValue
                                            }
                                        }
                                        $root.Parameters += $keyValue
                                    }
                                } else {
                                    $root.parameters = $convertedBuildStep.parameters
                                }

                                $convertedBuildStep.Remove('parameters')
                            }
                            if ($BuildSystem -in 'GitHubWorkflow','GitHubAction' -and $Root -and # If the BuildSystem was GitHub
                                $convertedBuildStep.parameters) {

                                if (
                                    $BuildSystem -eq 'GitHubAction' -or
                                    $convertedBuildStep.env.values -like '*.inputs.*' -and # and we have event inputs
                                    ($root.on.workflow_dispatch -is [Collections.IDictionary] -or # and we have a workflow_dispatch trigger.
                                    $root.on -eq 'workflow_dispatch' -or
                                    ($root.name -and $root.description)
                                )
                                ) {

                                    $ComparisonResult = $root.on -eq 'workflow_dispatch'
                                    $workflowDispatch =
                                        $workflowDispatch = [Ordered]@{ # Create an empty workflow_dispatch
                                            inputs = [Ordered]@{} # for inputs.
                                        }
                                    # If the result of root.on -eq 'workflow_dispatch' is a string
                                    if ($ComparisonResult -and $ComparisonResult -is [Object[]]) {
                                        $root.on = @( # on is already a list, so let's keep it that way.
                                            foreach ($o in $root.on) {
                                                if ($o -ne 'workflow_dispatch') { # anything that's not workflow_dispatch
                                                    $o # gets put back in order.
                                                } else {
                                                    [Ordered]@{ # and workflow_dispatch becomes
                                                        workflow_dispatch = $workflowDispatch
                                                    }
                                                }
                                            }
                                        )
                                    }
                                    elseif ($ComparisonResult -and # If root.on was 'workflow_dispatch'
                                        $ComparisonResult -is [bool]) { # and the result was a bool.
                                        $root.on = [Ordered]@{ # and workflow_dispatch becomes
                                                        workflow_dispatch = $workflowDispatch
                                                    }
                                    }
                                    elseif ($BuildSystem -eq 'GitHubAction') {
                                        if (-not $root.inputs) { $root.inputs = [Ordered]@{} }
                                        $workflowDispatch = $root
                                    } else {
                                        # Otherwise, we know that workflow_dispatch is already a dictionary
                                        $workflowDispatch = $root.on.workflow_dispatch
                                    }



                                    if ($workflowDispatch) {
                                        foreach ($convertedParam in $convertedBuildStep.parameters) {

                                            foreach ($keyValue in $convertedParam.GetEnumerator()) {
                                                $workflowDispatch.Inputs[$keyValue.Key] = $keyValue.Value
                                            }
                                        }
                                    }
                                }
                                $convertedBuildStep.Remove('parameters')
                            }
                            $convertedBuildStep
                        } else {
                            $v
                        }
                    }

                if ($DictionaryItemName -contains $propName) {
                    if (-not $outObject[$propName]) {
                        $outObject[$propName] = [Ordered]@{}
                    }
                    $outObject[$propName][$v] = $o
                    continue
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

            if ($outValue) {

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
        }
        $outObject

    }
}
