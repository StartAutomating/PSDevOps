function Convert-BuildStep
{
    <#
    .Synopsis
        Converts Build Steps into build system input
    .Description
        Converts Build Steps defined in a PowerShell script into build steps in a build system
    .Example
        Get-Command Convert-BuildStep | Convert-BuildStep
    #>
    param(
    # The name of the build step
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The Script Block that will be converted into a build step
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='ScriptBlock',ValueFromPipeline)]
    [ScriptBlock]
    $ScriptBlock,

    # The module that -ScriptBlock is declared in.  If piping in a command, this will be bound automatically
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='ScriptBlock')]
    [Management.Automation.PSModuleInfo]
    $Module,

    # The path to the file
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='ScriptBlock')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='PathAndExtension')]
    [Alias('Fullname')]
    [string]
    $Path,

    # The extension of the file
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='PathAndExtension')]
    [string]
    $Extension,


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

    # Default parameters for a build step
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $DefaultParameter = @{},

    # The build system.  Currently supported options, ADO and GitHubActions.  Defaulting to ADO.
    [ValidateSet('ADO', 'GitHubActions')]
    [string]
    $BuildSystem = 'ado'


    )

    begin {
        $MatchesAnyWildcard = {
            param([string[]]$text, [string[]]$Wildcard)
            foreach ($t in $text) {
                foreach ($wc in $Wildcard) {
                    if ($t -like $wc) {return $t }
                }
            }
            return $false
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'PathAndExtension') {

            if ($Extension -eq '.ps1')
            {
                $splatMe=  @{} + $PSBoundParameters
                $splatMe.Remove('Path')
                $splatMe.Remove('Extension')
                Get-Item -Path $path |
                    Get-Command { $_.FullName } |
                    Convert-BuildStep @splatMe
            }
            elseif ($Extension -eq '.sh')
            {
                [Ordered]@{bash="$ft";displayName=$metaData.Name}
            }
            return
        }

        $sbParams = "$(if ($ScriptBlock.Ast.ParamBlock) {
            $ScriptBlock.Ast.ParamBlock
        } elseif ($ScriptBlock.ast.Body.ParamBlock) {
            $ScriptBlock.Ast.Body.ParamBlock
        })"
        $definedParameters = @()
        if ($sbParams) {
            $function:_TempFunction = $ScriptBlock
            $tempCmd =
                $ExecutionContext.SessionState.InvokeCommand.GetCommand("_TempFunction",'Function')
            $tempCmdMd = [Management.Automation.CommandMetadata]$tempCmd

            $collectParameters = @(
                '$Parameters = @{}'

                foreach ($parameterName in $tempCmdMd.Parameters.Keys) {
                    $parameterAttributes = $tempCmdMd.Parameters[$parameterName].Attributes
                    $isMandatory =
                        foreach ($attr in $parameterAttributes) {
                            if ($attr.IsMandatory) { $true; break }
                        }


                    $disambiguatedParameter = $tempCmdMd.Name + '_' + $parameterName
                    $makeUnique = & $MatchesAnyWildcard $parameterName,$disambiguatedParameter $UniqueParameter

                    $VariableName =
                        & $MatchesAnyWildcard $disambiguatedParameter, $parameterName $VariableParameter

                    $EnvVariableName =
                        & $MatchesAnyWildcard $disambiguatedParameter, $parameterName $EnvironmentParameter
                    $paramType = $tempCmdMd.Parameters[$parameterName].ParameterType

                    $defaultValue =
                        if ($DefaultParameter[$thisParameter.Name]) {
                            $DefaultParameter[$thisParameter.Name]
                        } elseif ($DefaultParameter[$disambiguatedParameter]) {
                            $DefaultParameter[$disambiguatedParameter]
                        }
                    if ($BuildSystem -eq 'ado') {

                        $stepParamName = if ($makeUnique) { $disambiguatedParameter } else {$ParameterName}

                        if ($variableName)
                        {
                            "`$Parameters.$ParameterName = '`$($stepParamName)'"
                        }
                        elseif ($envVariableName)
                        {
                            "`$Parameters.$ParameterName = `$env:$($stepParamName)"
                        }
                        else
                        {
                            $thisParameter = @{
                                name = $stepParamName
                                type =
                                    $(if ([switch], [bool] -contains $paramType)
                                    {
                                        'boolean'
                                    }
                                    elseif ([int],[float],[double],[uint32],[byte], [long] -contains $paramType)
                                    {
                                        'number'
                                    }
                                    elseif ([string], [ScriptBlock] -contains $paramType -or
                                        $paramType.IsSubclassOf([Enum])) {
                                        'string'
                                    } else {
                                        'object'
                                    })
                            }
                            if ($paramType.IsSubclassOf([Enum])) {
                                $thisParameter.values = [Enum]::GetValues($paramType)
                            } else {
                                foreach ($attr in $parameterAttributes) {
                                    if ($attr -is [Management.Automation.ValidateSetAttribute]) {
                                        $thisParameter.values = $attr.ValidValues
                                        break
                                    }
                                }
                            }

                            if (-not $isMandatory) {
                                $thisParameter.defaultValue = ''
                                if ($thisParameter.ContainsKey('values')) {
                                    $thisParameter.values = @('') + $thisParameter.values
                                }
                            }

                            if ($null -ne $defaultValue) {
                                $thisParameter.defaultValue = $DefaultParameter
                            }



                            $definedParameters += $thisParameter
                            "`$Parameters.$ParameterName = `${{parameters.$stepParamName}}"
                        }
                    }
                }

                if ($tempCmdmd.SupportsShouldProcess) {
                    '$Parameters.Confirm = $false'
                }
                @'
foreach ($k in @($parameters.Keys)) {
    if ([String]::IsNullOrEmpty($parameters[$k])) {
        $parameters.Remove($k)
    }
}
'@
            )
            $collectParameters =
                    $collectParameters -join [Environment]::NewLine -replace '\$\{','`${'

            if ($Name -and $Module) {
                $modulePathVariable = "${Module}Path"
                $sb = [ScriptBlock]::Create(@"
$collectParameters
Import-Module `$($modulePathVariable) -Force -PassThru
$Name `@Parameters
"@)
                $ScriptBlock = $sb
            } else {
                $sb = [scriptBlock]::Create(@"
$CollectParameters
& {$ScriptBlock} `@Parameters
"@)
                $ScriptBlock = $sb
            }
            Remove-Item -Force function:_TempFunction
        }
        $out = [Ordered]@{}
        if ($BuildSystem -eq 'ADO') {
            if ($outObject.pool -and $outObject.pool.vmimage -notlike '*win*') {
                $out.pwsh = "$ScriptBlock" -replace '`\$\{','${'
            } else {
                $out.powershell = "$ScriptBlock" -replace '`\$\{','${'
            }
            $out.displayName = $Name
            if ($definedParameters) {
                $out.parameters = $definedParameters
            }
            if ($UseSystemAccessToken) {
                $out.env = @{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}
            }
        } elseif ($BuildSystem -eq 'GitHubActions') {
            $out.name = $Name
            $out.runs = "$ScriptBlock"
            $out.shell = 'pwsh'
        }
        $out
    }
}
