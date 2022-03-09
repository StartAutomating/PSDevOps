#region Piecemeal [ 0.1.10 ] : Easy Extensible Plugins for PowerShell
# Install-Module Piecemeal -Scope CurrentUser 
# Import-Module Piecemeal -Force 
# Install-Piecemeal -ExtensionModule 'PSDevOps' -ExtensionModuleAlias 'psdo' -ExtensionTypeName 'PSDevOps.Extension' -OutputPath '.\Get-PSDevOpsExtension.ps1'
function Get-PSDevOpsExtension
{
    <#
    .Synopsis
        Gets Extensions
    .Description
        Gets Extensions.

        PSDevOps Extensions can be found in:

        * Any module that includes -ExtensionModuleName in it's tags.
        * The directory specified in -ExtensionPath
    .Example
        Get-PSDevOpsExtension
    #>
    [OutputType('Extension')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification="PSScriptAnalyzer cannot handle nested scoping")]
    param(
    # If provided, will look beneath a specific path for extensions.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $ExtensionPath,

    # If set, will clear caches of extensions, forcing a refresh.
    [switch]
    $Force,

    # If provided, will get PSDevOps Extensions that extend a given command
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ThatExtends', 'For')]
    [string[]]
    $CommandName,

    # The name of an extension
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]    
    [string[]]
    $ExtensionName,

    # If provided, will treat -ExtensionName as a wildcard.
    [Parameter(ValueFromPipelineByPropertyName)]    
    [switch]
    $Like,

    # If provided, will treat -ExtensionName as a regular expression.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Match,

    # If set, will return the dynamic parameters object of all the PSDevOps Extensions for a given command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $DynamicParameter,

    # If set, will return if the extension could run
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CanRun')]
    [switch]
    $CouldRun,
    
    # If set, will run the extension.  If -Stream is passed, results will be directly returned.
    # By default, extension results are wrapped in a return object.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Run,

    # If set, will stream output from running the extension.
    # By default, extension results are wrapped in a return object.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Stream,

    # If set, will return the dynamic parameters of all PSDevOps Extensions for a given command, using the provided DynamicParameterSetName.
    # Implies -DynamicParameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DynamicParameterSetName,


    # If provided, will return the dynamic parameters of all PSDevOps Extensions for a given command, with all positional parameters offset.
    # Implies -DynamicParameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $DynamicParameterPositionOffset = 0,

    # If set, will return the dynamic parameters of all PSDevOps Extensions for a given command, with all mandatory parameters marked as optional.
    # Implies -DynamicParameter.  Does not actually prevent the parameter from being Mandatory on the Extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('NoMandatoryDynamicParameters')]
    [switch]
    $NoMandatoryDynamicParameter,

    # If set, will validate this input against [ValidateScript], [ValidatePattern], and [ValidateSet] attributes found on an extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $ValidateInput,

    # The name of the parameter set.  This is used by -CouldRun and -Run to enforce a single specific parameter set.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ParameterSetName,

    # The parameters to the extension.  Only used when determining if the extension -CouldRun.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    [Alias('Parameters','ExtensionParameter','ExtensionParameters')]
    $Parameter = @{}
    )

    begin {
        $ExtensionPattern = '(?<!-)(extension|ext|ex|x)\.ps1$'
        $ExtensionModule = 'PSDevOps'
        $ExtensionModuleAlias = 'psdo'
        $ExtensionTypeName = 'PSDevOps.Extension'
        #region Define Inner Functions
        function WhereExtends {
            param(
            [Parameter(Position=0)]
            [string[]]
            $Command,

            [Parameter(ValueFromPipeline)]
            [PSObject]
            $ExtensionCommand
            )
            process {
                if ($ExtensionName) {
                    :CheckExtensionName do {
                        foreach ($exn in $ExtensionName) {
                            if ($like) { 
                                if ($extensionCommand -like $exn) { break CheckExtensionName }
                            }
                            elseif ($match) {
                                if ($ExtensionCommand -match $exn) { break CheckExtensionName }
                            }
                            elseif ($ExtensionCommand -eq $exn) { break CheckExtensionName }
                        }
                        return
                    } while ($false)                    
                }
                if ($Command) {
                    foreach ($ext in $ExtensionCommand.ExtensionCommands) {
                        if ($ext.Name -in $command) {
                            $commandExtended = $ext
                            return $ExtensionCommand
                        }
                    }
                }
                elseif (-not $command) {
                    return $ExtensionCommand
                }
            }

        }
        filter ConvertToExtension {
            $in = $_
            $extCmd =
                if ($in -is [Management.Automation.CommandInfo]) {
                    $in
                }
                elseif ($in -is [IO.FileInfo]) {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($in.fullname, 'ExternalScript')
                }
                else {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($in, 'Function,ExternalScript')
                }

            $hasExtensionAttribute = $false
            $extends     = @()
            $inheritanceLevel = [ComponentModel.InheritanceLevel]::Inherited
            foreach ($attr in $extCmd.ScriptBlock.Attributes) {
                if ($attr -is [Runtime.CompilerServices.ExtensionAttribute]) {
                    $hasExtensionAttribute = $true
                }
                if ($attr -is [Management.Automation.CmdletAttribute]) {
                    $extensionCommandName = (
                        ($attr.VerbName -replace '\s') + '-' + ($attr.NounName -replace '\s')
                    ) -replace '^\-' -replace '\-$'
                    $extends +=
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($extensionCommandName, 'Function')
                }
                if ($attr -is [ComponentModel.InheritanceAttribute]) {
                    $inheritanceLevel = $attr.InheritanceLevel
                }
            }

            if (-not $hasExtensionAttribute -and $RequireExtensionAttribute) { return }
            if (-not $extends -and $RequireExtensionAttribute) { return }

            $extCmd.PSObject.Properties.Add([PSNoteProperty]::new('Extends', $extends.Name))
            $extCmd.PSObject.Properties.Add([PSNoteProperty]::new('ExtensionCommands', $extends))
            $extCmd.PSObject.Properties.Add([PSNoteProperty]::new('InheritanceLevel', $inheritanceLevel))
            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'DisplayName', [ScriptBlock]::Create("`$this.Name -replace '$extensionFullRegex'")
            ))
            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Attributes', {$this.ScriptBlock.Attributes}
            ))
            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Rank', {
                    foreach ($attr in $this.ScriptBlock.Attributes) {
                        if ($attr -is [Reflection.AssemblyMetaDataAttribute] -and 
                            $attr.Key -in 'Order', 'Rank') {
                            return $attr.Value -as [int]
                        }
                    }
                    return 0
                }
            ))
            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Description',
                {
                    # From ?<PowerShell_HelpField> in Irregular (https://github.com/StartAutomating/Irregular)
                    [Regex]::new('
                        \.(?<Field>Description)              # Field Start
                        \s{0,}                               # Optional Whitespace
                        (?<Content>(.|\s)+?(?=(\.\w+|\#\>))) # Anything until the next .\field or end of the comment block
                        ', 'IgnoreCase,IgnorePatternWhitespace', [Timespan]::FromSeconds(1)).Match(
                            $this.ScriptBlock
                    ).Groups["Content"].Value
                }
            ))


            $extCmd.PSObject.Properties.Add([PSScriptProperty]::new(
                'Synopsis', {
                # From ?<PowerShell_HelpField> in Irregular (https://github.com/StartAutomating/Irregular)
                [Regex]::new('
                    \.(?<Field>Synopsis)                 # Field Start
                    \s{0,}                               # Optional Whitespace
                    (?<Content>(.|\s)+?(?=(\.\w+|\#\>))) # Anything until the next .\field or end of the comment block
                    ', 'IgnoreCase,IgnorePatternWhitespace', [Timespan]::FromSeconds(1)).Match(
                        $this.ScriptBlock
                ).Groups["Content"].Value
            }))

            $extCmd.PSObject.Methods.Add([psscriptmethod]::new('Validate', {
                param([PSObject]$ValidateInput)

                try {
                    # We can attempt to create a variable using our attributes and $validateInput
                    [psvariable]::new("validating", $ValidateInput, 'None', $this.Attributes)
                } catch {
                    $ex = $_ # If this throws an exception, we may wish to clean it up.
                    foreach ($attr in $this.ScriptBlock.Attributes) {
                        if ($attr -is [Management.Automation.ValidateSetAttribute]) {
                            if ($ValidateInput -notin $attr.ValidValues) {
                                throw "'$ValidateInput' is not a valid value.  Valid values are '$(@($attr.ValidValues) -join "','")'"
                            }
                        }
                        if ($attr -is [Management.Automation.ValidatePatternAttribute]) {
                            $matched = [Regex]::new($attr.RegexPattern, $attr.Options, [Timespan]::FromSeconds(1)).Match($ValidateInput)
                            if (-not $matched.Success) {
                                throw "'$ValidateInput' is not a valid value.  Valid values must match the pattern '$($attr.RegexPattern)'"
                            }
                        }
                        if ($attr -is [Management.Automation.ValidateRangeAttribute]) {
                            if ($null -ne $attr.MinRange -and $validateInput -lt $attr.MinRange) {
                                throw "'$ValidateInput' is below the minimum range [ $($attr.MinRange)-$($attr.MaxRange) ]"
                            }
                            if ($null -ne $attr.MaxRange -and $validateInput -gt $attr.MaxRange) {
                                throw "'$ValidateInput' is above the maximum range [ $($attr.MinRange)-$($attr.MaxRange) ]"
                            }
                        }
                    }
                    throw $ex.Exception
                }
                return $true
            }))

            $extCmd.PSObject.Methods.Add([PSScriptMethod]::new('GetDynamicParameters', {
                param(
                [string]
                $ParameterSetName,

                [int]
                $PositionOffset,

                [switch]
                $NoMandatory,

                [string[]]
                $commandList
                )

                $ExtensionDynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
                $Extension = $this
                
                :nextDynamicParameter foreach ($in in @(([Management.Automation.CommandMetaData]$Extension).Parameters.Keys)) {
                    $attrList = [Collections.Generic.List[Attribute]]::new()
                    $validCommandNames = @()
                    foreach ($attr in $extension.Parameters[$in].attributes) {
                        if ($attr -isnot [Management.Automation.ParameterAttribute]) {
                            # we can passthru any non-parameter attributes
                            $attrList.Add($attr)
                            if ($attr -is [Management.Automation.CmdletAttribute] -and $commandList) {
                                $validCommandNames += (
                                    ($attr.VerbName -replace '\s') + '-' + ($attr.NounName -replace '\s')
                                ) -replace '^\-' -replace '\-$'
                            }
                        } else {
                            # but parameter attributes need to copied.
                            $attrCopy = [Management.Automation.ParameterAttribute]::new()
                            # (Side note: without a .Clone, copying is tedious.)
                            foreach ($prop in $attrCopy.GetType().GetProperties('Instance,Public')) {
                                if (-not $prop.CanWrite) { continue }
                                if ($null -ne $attr.($prop.Name)) {
                                    $attrCopy.($prop.Name) = $attr.($prop.Name)
                                }
                            }

                            $attrCopy.ParameterSetName =                                
                                if ($ParameterSetName) {
                                    $ParameterSetName
                                }
                                else {
                                    $defaultParamSetName = 
                                        foreach ($extAttr in $Extension.ScriptBlock.Attributes) {
                                            if ($extAttr.DefaultParameterSetName) {
                                                $extAttr.DefaultParameterSetName
                                                break
                                            }
                                        }
                                    if ($attrCopy.ParameterSetName -ne '__AllParameterSets') {
                                        $attrCopy.ParameterSetName
                                    }
                                    elseif ($defaultParamSetName) {
                                        $defaultParamSetName
                                    }
                                    elseif ($this -is [Management.Automation.FunctionInfo]) {
                                        $this.Name
                                    } elseif ($this -is [Management.Automation.ExternalScriptInfo]) {
                                        $this.Source
                                    }
                                }
                                                                
                            if ($NoMandatory -and $attrCopy.Mandatory) {
                                $attrCopy.Mandatory = $false
                            }

                            if ($PositionOffset -and $attr.Position -ge 0) {
                                $attrCopy.Position += $PositionOffset
                            }
                            $attrList.Add($attrCopy)
                        }
                    }


                    if ($commandList -and $validCommandNames) {
                        :CheckCommandValidity do { 
                            foreach ($vc in $validCommandNames) {
                                if ($commandList -contains $vc) { break CheckCommandValidity }
                            }
                            continue nextDynamicParameter
                        } while ($false)
                    }
                    $ExtensionDynamicParameters.Add($in, [Management.Automation.RuntimeDefinedParameter]::new(
                        $Extension.Parameters[$in].Name,
                        $Extension.Parameters[$in].ParameterType,
                        $attrList
                    ))
                }

                $ExtensionDynamicParameters

            }))

            $extCmd.PSObject.Methods.Add([PSScriptMethod]::new('CouldRun', {
                param([Collections.IDictionary]$params, [string]$ParameterSetName)

                :nextParameterSet foreach ($paramSet in $this.ParameterSets) {
                    if ($ParameterSetName -and $paramSet.Name -ne $ParameterSetName) { continue }
                    $mappedParams = [Ordered]@{} # Create a collection of mapped parameters
                    $mandatories  =  # Walk thru each parameter of this command                
                        @(foreach ($myParam in $paramSet.Parameters) {
                            if ($params.Contains($myParam.Name)) { # If this was in Params,
                                $mappedParams[$myParam.Name] = $params[$myParam.Name] # then map it.
                            } else {
                                foreach ($paramAlias in $myParam.Aliases) { # Otherwise, check the aliases
                                    if ($params.Contains($paramAlias)) { # and map it if the parameters had the alias.
                                        $mappedParams[$myParam.Name] = $params[$paramAlias]
                                        break
                                    }
                                }
                            }
                            if ($myParam.IsMandatory) { # If the parameter was mandatory,
                                $myParam.Name # keep track of it.
                            }
                        })
                    foreach ($mandatoryParam in $mandatories) { # Walk thru each mandatory parameter.
                        if (-not $params.Contains($mandatoryParam)) { # If it wasn't in the parameters.
                            continue nextParameterSet
                        }
                    }
                    return $mappedParams                        
                }
                return $false
            }))

            $extCmd.pstypenames.clear()
            if ($ExtensionTypeName) {
                $extCmd.pstypenames.add($ExtensionTypeName)
            } else {
                $extCmd.pstypenames.add('Extension')
            }

            $extCmd
        }
        function OutputExtension {
            begin {
                $allDynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
            }
            process {
                $extCmd = $_
                if ($ValidateInput) {
                    try {
                        if (-not $extCmd.Validate($ValidateInput)) {
                            return
                        }
                    } catch {
                        Write-Error $_
                        return
                    }
                }
                

                if ($DynamicParameter -or $DynamicParameterSetName -or $DynamicParameterPositionOffset -or $NoMandatoryDynamicParameter) {
                    $extensionParams = $extCmd.GetDynamicParameters($DynamicParameterSetName, $DynamicParameterPositionOffset, $NoMandatoryDynamicParameter, $CommandName)
                    foreach ($kv in $extensionParams.GetEnumerator()) {
                        if ($commandExtended -and ([Management.Automation.CommandMetaData]$commandExtended).Parameters.$($kv.Key)) {
                            continue
                        }
                        if ($allDynamicParameters.ContainsKey($kv.Key)) {
                            if ($kv.Value.ParameterType -ne $allDynamicParameters[$kv.Key].ParameterType) {
                                Write-Verbose "Extension '$extCmd' Parameter '$($kv.Key)' Type Conflict, making type PSObject"
                                $allDynamicParameters[$kv.Key].ParameterType = [PSObject]
                            }
                            foreach ($attr in $kv.Value.Attributes) {
                                if ($allDynamicParameters[$kv.Key].Attributes.Contains($attr)) {
                                    continue
                                }
                                $allDynamicParameters[$kv.Key].Attributes.Add($attr)
                            }
                        } else {
                            $allDynamicParameters[$kv.Key] = $kv.Value
                        }
                    }
                }
                elseif ($CouldRun) {
                    if (-not $extCmd) { return }
                    $couldRunExt = $extCmd.CouldRun($Parameter, $ParameterSetName)
                    if (-not $couldRunExt) { return }
                    [PSCustomObject][Ordered]@{
                        ExtensionCommand = $extCmd
                        CommandName = $CommandName
                        ExtensionParameter = $couldRunExt
                    }

                    return
                }
                elseif ($Run) {
                    if (-not $extCmd) { return }
                    $couldRunExt = $extCmd.CouldRun($Parameter, $ParameterSetName)
                    if (-not $couldRunExt) { return }
                    if ($extCmd.InheritanceLevel -eq 'InheritedReadOnly') { return }
                    if ($Stream) {
                        & $extCmd @couldRunExt
                    } else {
                        [PSCustomObject][Ordered]@{
                            CommandName      = $CommandName
                            ExtensionCommand = $extCmd
                            ExtensionOutput  = & $extCmd @couldRunExt
                            Done             = $extCmd.InheritanceLevel -eq 'NotInherited'
                        }
                    }
                    return
                }
                else {
                    return $extCmd
                }
            }
            end {
                if ($DynamicParameter) {
                    return $allDynamicParameters
                }
            }
        }
        #endregion Define Inner Functions


        $extensionFullRegex =
            if ($ExtensionModule) {
                "\.(?>$(@(@($ExtensionModule) + $ExtensionModuleAlias) -join '|'))\." + $ExtensionPattern
            } else {
                $ExtensionPattern
            }

        #region Find Extensions
        $loadedModules = @(Get-Module)
        $myInv = $MyInvocation
        $myModuleName = if ($ExtensionModule) { $ExtensionModule } else {$MyInvocation.MyCommand.Module.Name }
        if ($myInv.MyCommand.Module -and $loadedModules -notcontains $myInv.MyCommand.Module) {
            $loadedModules = @($myInv.MyCommand.Module) + $loadedModules
        }
        $getCmd    = $ExecutionContext.SessionState.InvokeCommand.GetCommand

        if ($Force) {
            $script:PSDevOpsExtensions = $null
        }
        if (-not $script:PSDevOpsExtensions)
        {
            $script:PSDevOpsExtensions =
                @(
                #region Find PSDevOps Extensions in Loaded Modules
                foreach ($loadedModule in $loadedModules) { # Walk over all modules.
                    if ( # If the module has PrivateData keyed to this module
                        $loadedModule.PrivateData.$myModuleName
                    ) {
                        # Determine the root of the module with private data.
                        $thisModuleRoot = [IO.Path]::GetDirectoryName($loadedModule.Path)
                        # and get the extension data
                        $extensionData = $loadedModule.PrivateData.$myModuleName
                        if ($extensionData -is [Hashtable]) { # If it was a hashtable
                            foreach ($ed in $extensionData.GetEnumerator()) { # walk each key

                                $extensionCmd =
                                    if ($ed.Value -like '*.ps1') { # If the key was a .ps1 file
                                        $getCmd.Invoke( # treat it as a relative path to the .ps1
                                            [IO.Path]::Combine($thisModuleRoot, $ed.Value),
                                            'ExternalScript'
                                        )
                                    } else { # Otherwise, treat it as the name of an exported command.
                                        $loadedModule.ExportedCommands[$ed.Value]
                                    }
                                if ($extensionCmd) { # If we've found a valid extension command
                                    $extensionCmd | ConvertToExtension # return it as an extension.
                                }
                            }
                        }
                    }
                    elseif ($loadedModule.PrivateData.Tags -contains $myModuleName -or $loadedModule.Name -eq $myModuleName) {
                        $loadedModule |
                            Split-Path |
                            Get-ChildItem -Recurse |
                            Where-Object Name -Match $extensionFullRegex |
                            ConvertToExtension
                    }
                }
                #endregion Find PSDevOps Extensions in Loaded Modules
                )
        }
        #endregion Find Extensions
    }

    process {

        if ($ExtensionPath) {
            Get-ChildItem -Recurse -Path $ExtensionPath |
                Where-Object Name -Match $extensionFullRegex |
                ConvertToExtension |
                . WhereExtends $CommandName |
                Sort-Object Rank, Name |
                OutputExtension
        } else {
            $script:PSDevOpsExtensions |
                . WhereExtends $CommandName |                
                Sort-Object Rank, Name |
                OutputExtension
        }
    }
}
#endregion Piecemeal [ 0.1.10 ] : Easy Extensible Plugins for PowerShell

