function Convert-BuildStep
{
    <#
    .Synopsis
        Converts Build Steps into build system input
    .Description
        Converts Build Steps defined in a PowerShell script into build steps in a build system
    .Example
        Get-Command Convert-BuildStep | Convert-BuildStep
    .Link
        Import-BuildStep
    .Link
        Expand-BuildStep
    #>
    [CmdletBinding(DefaultParameterSetName='ScriptBlock')]
    [OutputType([Collections.IDictionary])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "",
        Justification="ScriptAnalyzer False Positive")]
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

    # The name of parameters that should be supplied from event input.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('InputParameters')]
    [Collections.IDictionary]
    $InputParameter,

    # The name of parameters that should be supplied from build variables.
    # Wildcards accepted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('VariableParameters')]
    [string[]]
    $VariableParameter,

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

    # Default parameters for a build step
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $DefaultParameter = @{},

    # The build system.  Currently supported options, ADO and GitHub.  Defaulting to ADO.
    [ValidateSet('ADOPipeline', 'GitHubWorkflow')]
    [string]
    $BuildSystem = 'ADOPipeline',

    # Options for the build system.  The can contain any additional parameters passed to the build system.
    [PSObject]
    $BuildOption
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
        # If we have been given a path and an extension,
        if ($PSCmdlet.ParameterSetName -eq 'PathAndExtension') {
            if ($Extension -eq '.ps1') # and that extension is .ps1
            {
                $splatMe=  @{} + $PSBoundParameters # then we recursively call ourselves.
                $splatMe.Remove('Path') # Before we do, take out the -Path and
                $splatMe.Remove('Extension') # -Extension parameters.
                Get-Item -LiteralPath $path |# Get the script file,
                    Get-Command { $_.FullName } | # resolve it to a command
                    Convert-BuildStep @splatMe    # pipe that input to ourselves.
            }
            elseif ($Extension -eq '.sh') # The other extension we know how to deal with is .sh
            {
                $shellScript = Get-Content -LiteralPath $path -Raw
                if ($BuildSystem -eq 'ADOPipeline') { # If the buildsystem is Azure DevOps
                    [Ordered]@{
                        bash= $shellScript
                        displayName=$Name
                    } # echo out a bash: step.
                } elseif ($BuildSystem -eq 'GitHubWorkflow') {
                    [Ordered]@{
                        name=$Name
                        run=$shellScript
                        shell='bash'
                    }
                }

            }
            elseif ($Extension -eq '.py') {
                $pythonScript = Get-Content -LiteralPath $path -Raw
                if ($BuildSystem -eq 'ADOPipeline') {
                    [Ordered]@{
                        task = 'PythonScript@0'
                        inputs = [Ordered]@{
                            scriptSource = 'inline'
                            script = $pythonScript
                        }
                    }
                }
                elseif ($BuildSystem -eq 'GitHubWorkflow') {
                    [Ordered]@{
                        name = $Name
                        run = $pythonScript
                        shell = 'python'
                    }
                }
            }
            return
        }
        $innerScript = "$ScriptBlock"

        $sbParams = # Determine if script block had parameters, by examining AST.
            if ($ScriptBlock.Ast.ParamBlock) {
                $ScriptBlock.Ast.ParamBlock
            } elseif ($ScriptBlock.ast.Body.ParamBlock) {
                $ScriptBlock.Ast.Body.ParamBlock
            }
        $definedParameters = @()
        $eventParameters   = @{}
        if ($sbParams) { # If it had parameters,
            $executionContext.SessionState.PSVariable.set('function:_TempFunction', $ScriptBlock) # create a temporary function
            $tempCmd =
                $ExecutionContext.SessionState.InvokeCommand.GetCommand("_TempFunction",'Function')
            $tempCmdMd = [Management.Automation.CommandMetadata]$tempCmd # and get it's command metadata

            #region Accumulate Parameter Script
            $collectParameters = @(
                '$Parameters = @{}' # First, we'll create a hashtable to store the parameters.

                foreach ($parameterName in $tempCmdMd.Parameters.Keys) { # Then we'll walk thru each parameter,
                    $parameterAttributes = $tempCmdMd.Parameters[$parameterName].Attributes
                    $isMandatory = # determine if it is mandatory
                        foreach ($attr in $parameterAttributes) {
                            if ($attr.IsMandatory) { $true; break }
                        }

                    # and create a 'disambiguated' parameter name
                    $disambiguatedParameter = $Name + '_' + $parameterName # (e.g. Get-Command_Syntax).
                    $shouldExclude = # Next, we see if it should be excluded
                        & $MatchesAnyWildCard $disambiguatedParameter, $parameterName $ExcludeParameter
                    if ($shouldExclude) { continue } # if so continue.


                    $defaultValue =
                        # If we provided a default value for the disambiguated parameter,
                        if ($DefaultParameter[$disambiguatedParameter])
                        {
                            $DefaultParameter[$disambiguatedParameter]  # use that as the default value.
                        }
                        # Otherwise, if we have provided a default by name,
                        elseif ($DefaultParameter[$parameterName])
                        {
                            $DefaultParameter[$parameterName]           # use that as the default.
                        }
                        # Otherwise, the default value can be found with the AST.
                        else
                        {
                            foreach ($param in $sbParams.Parameters) {
                                if ($parameterName -eq $param.Name.VariablePath) {
                                    if ($param.DefaultValue.SubExpression) { # If the default value was a subexpression
                                        break # then break, which will actually have a blank default.
                                        # This is desirable, because otherwise, we have to allow string expansion on _any_ incoming parameter
                                        # Doing that would allow generic code injection into a pipeline, which we do not want.
                                    }
                                    "$($param.DefaultValue)"
                                    break
                                }
                            }
                        }

                    # No matter the build system, we'll probably want to know a few things about the parameter.
                    $paramType = $tempCmdMd.Parameters[$parameterName].ParameterType


                    # Determine if it needs to be made unique.
                    $makeUnique = & $MatchesAnyWildcard $parameterName,$disambiguatedParameter $UniqueParameter

                    # What the step parameter name would be (which depends on -MakeUnique).
                    $stepParamName = if ($makeUnique) { $disambiguatedParameter } else {$ParameterName}


                    # In Azure DevOps pipelines, we can pass parameters as a variable.
                    # In GitHub Workflows, variables can come from secrets.
                    $VariableName =
                        & $MatchesAnyWildcard $disambiguatedParameter, $parameterName $VariableParameter


                    if ($BuildSystem -eq 'ADOPipeline') {

                        # In Azure DevOps pipelines, we can also get parameters from the environment.
                        $EnvVariableName =
                            & $MatchesAnyWildcard $disambiguatedParameter, $parameterName $EnvironmentParameter


                        # If we wanted to pass this parameter as a variable,
                        if ($variableName)
                        {
                            # The syntax is like PowerShell string expansion, so put it in single quotes to be safe.
                            "`$Parameters.$ParameterName = '`$($stepParamName)'"
                        }
                        # If wanted to pass this parameter as an environment variable
                        elseif ($envVariableName)
                        {
                            "`$Parameters.$ParameterName = `${env:$($stepParamName)}" # just use the environment provider.
                        }
                        # If we wanted this parameter to become a parameter for the pipeline
                        else
                        {
                            # We have to create it.
                            $thisParameter = [Ordered]@{
                                name = $stepParamName # The name we already know
                                type = # how it maps to Azure DevOps' parameter types gets tedious:
                                    $(
                                    # If it was a [switch] or a [bool],
                                    if ([switch], [bool] -contains $paramType)
                                    {
                                        'boolean' # in Azure DevOps, it's a boolean
                                    }
                                    # [int]s, [float]s, [double]s, [uint32]s, [byte], and [long]s become
                                    elseif ([int],[float],[double],[uint32],[byte], [long] -contains $paramType)
                                    {
                                        'number' # numbers in Azure DevOps.
                                    }
                                    elseif ([string], # any number of other safe types
                                        [Version],
                                        [DateTime],
                                        [TimeSpan],
                                        [DateTime[]],
                                        [ScriptBlock],[ScriptBlock[]],
                                        [string[]],
                                        [int[]],
                                        [float[]] -contains $paramType -or
                                        $paramType.IsSubclassOf([Enum])) {
                                        'string' # will be considered a string
                                    }
                                    # otherwise, we'll treat it as an object
                                    else
                                    {
                                        'object'
                                        # (though passing it down is currently so simple).
                                    }
                                    )
                            }
                            if ($paramType.IsSubclassOf([Enum])) { # If the parameter is an enum,
                                $thisParameter.values = [Enum]::GetValues($paramType)
                            } else {
                                foreach ($attr in $parameterAttributes) { # or if the parameter has a ValidateSet
                                    if ($attr -is [Management.Automation.ValidateSetAttribute]) {
                                        $thisParameter.values = $attr.ValidValues # we know a list of valid values
                                        break
                                    }
                                }
                            }

                            if (-not $isMandatory) { # If the parameter was not mandatory
                                $thisParameter.default = if ($paramType -eq [switch]) { $false} else {''} # default to blank
                                if ($thisParameter.Contains('values')) { # if it had valid values
                                    $thisParameter.values = @('') + $thisParameter.values # default those values to blank.
                                }
                            }

                            if (-not [String]::IsNullOrEmpty($defaultValue)) { # If we have a default,
                                $thisParameter.default = $defaultValue # set it on the object
                            }

                            $definedParameters += $thisParameter # keep track of which parameters we define
                            "`$Parameters.$ParameterName = @'
`${{parameters.$stepParamName}}
'@"                         # and output the text to bind to this parameter.
                        }
                    }

                    if ($BuildSystem -eq 'GitHubWorkflow') {
                        # In GitHub Workflows, variables can come from an event.
                        $eventName =
                            & $MatchesAnyWildcard $disambiguatedParameter, $parameterName $InputParameter.Keys

                        if ($variableName) {
                            $eventParameters[$stepParamName] = "`${{secrets.$stepParamName}}"
                        }
                        if ($eventName) {
                            foreach ($evt in $eventName) {


                                if ($evt -match '\.(?:\*)?$') {
                                    $evt = ($evt -replace '\.(?:\*)?$') + '.' + $stepParamName
                                }
                                if ($evt -notlike '${{*' -and $evt -notlike '*.*') {
                                    $evt = 'github.events.inputs' + '.' + $stepParamName
                                }
                                if ($evt -notlike '${{*' -and $evt -notlike 'github.*') {
                                    $evt = "github." + '.' + $stepParamName
                                }
                                if ($evt -like '${{*') {
                                    $eventParameters[$stepParamName] = $evt
                                }
                                else {
                                    $eventParameters[$stepParamName] = "`${{$evt}}"
                                }

                            }

                            # Event parameters might come from workflow_dispatch, so we have to prepare the parameter information.

                            $thisParameter = [Ordered]@{
                                $stepParamName = [Ordered]@{
                                    required = $isMandatory -as [bool]
                                }
                            }

                            if (-not [String]::IsNullOrEmpty($defaultValue)) { # If we have a default,
                                $thisParameter.$stepParamName.default = $defaultValue # set it on the object
                            }

                            $parameterHelp = Get-Command _tempFunction -ErrorAction SilentlyContinue |
                                Get-Help -Parameter $parameterName -ErrorAction SilentlyContinue

                            if ($parameterHelp.description.text) {
                                $thisParameter.$stepParamName.description = ($parameterHelp.description.text | Out-String -Width 1kb).Trim()
                            }

                            $definedParameters += $thisParameter
                        }
                        "`$Parameters.$ParameterName = `${env:$($stepParamName)}"
                    }
                     # If the parameter type was and [int[]], [string[]], or [float[]],
                    if ([int[]], [string[]],[float[]] -contains $paramType) {
                        # it can be split by semicolons.
                        "`$Parameters.$ParameterName = `$parameters.$ParameterName -split ';'"
                    }
                    if ([switch], [bool] -contains $paramType) {
                        "`$Parameters.$ParameterName = `$parameters.$ParameterName -match 'true';"
                    }
                    # If the parameter type was a scriptblock
                    if ([ScriptBlock], [ScriptBlock[]] -contains $paramType) {
                        "`$Parameters.$ParameterName = foreach (`$p in `$parameters.$ParameterName){ [ScriptBlock]::Create(`$p) }"
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
            $logParameters =
                @(
                if ($BuildSystem -eq 'ADOPipeline') {
                    'Write-Host "##[command]'
                } elseif ($BuildSystem -eq 'GitHubWorkflow') {
                    'Write-Host "::debug::'
                }
                if ($name) { $name} 
                '$(@(foreach ($p in $Parameters.GetEnumerator()) {''-'' + $p.Key + '' '' + $p.Value}) -join '' '')"'
                ) -join ' '
            #endregion Accumulate Parameter Script
            if ($Name -and $Module) { # if the command we're converting came from a module
                $modulePathVariable = "${Module}Path"
                $sb = [ScriptBlock]::Create(@"
$collectParameters
Import-Module `$($modulePathVariable) -Force -PassThru
$logParameters
$Name `@Parameters
"@)
                $innerScript = $sb
            } else {
                $sb = [scriptBlock]::Create(@"
$CollectParameters
$logParameters
& {$ScriptBlock} `@Parameters
"@)
                $innerScript = $sb
            }
            Remove-Item -Force function:_TempFunction
        }
        $out = [Ordered]@{}
        if ($BuildSystem -eq 'ADOPipeline') {
            if ($DebugPreference -ne 'silentlycontinue') {
                $innerScript = @"
try {
    $innerScript
} catch {
    `$err = `$_;
    `"##[error]`$(`$_ | Out-String)`";
    `$_| Write-Error
}
"@
            }
            if (
                ($outObject.pool -and $outObject.pool.vmimage -notlike '*win*' -and
                    (-not $BuildOption.WindowsPowerShell)
                ) -or $BuildOption.PowerShellCore
            ) {
                $out.pwsh = "$innerScript" -replace '`\$\{','${'
            } else {
                $out.powershell = "$innerScript" -replace '`\$\{','${'
            }
            $out.displayName = $Name
            if ($definedParameters) {
                $out.parameters = $definedParameters
            }
            if ($BuildOption.UseSystemAccessToken) {
                if (-not $out.env) { $out.env = @{}}
                $out.env."SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'
            }
        } elseif ($BuildSystem -eq 'GitHubWorkflow') {
            if ($DebugPreference -ne 'silentlycontinue') {
                $innerScript = @"
try {
    $innerScript
} catch {
    `$err = `$_;
    `"::error::`$(`$_ | Out-String)`";
    `$_| Write-Error
}
"@
            }
            $out.name = $Name
            $out.shell = 'pwsh'
            if ($eventParameters.Count) {
                if (-not $out.env) { $out.env = @{}}
                foreach ($ep in $eventParameters.GetEnumerator()) {
                    $out.env[$ep.Key] = $ep.value
                }
            }
            if ($definedParameters) {
                $out.parameters = $definedParameters
            }
            $out.run = "$innerScript" -replace '`\$\{','${'
        }
        $out
    }
}
