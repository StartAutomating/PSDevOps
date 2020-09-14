function New-ADOPipeline
{
    <#
    .Synopsis
        Creates a new ADO Pipeline
    .Description
        Create a new Azure DevOps Pipeline.
    .Example
        New-ADOPipeline -Trigger SourceChanged -Stage PowerShellStaticAnalysis,TestPowerShellCrossPlatForm, UpdatePowerShellGallery
    .Example
        New-ADOPipeline -Trigger SourceChanged -Stage PowerShellStaticAnalysis,TestPowerShellCrossPlatForm, UpdatePowerShellGallery -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}}
    .Link
        Convert-BuildStep
    .Link
        Import-BuildStep
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for null (0 is ok)")]
    [OutputType([string],[PSObject])]
    param(
    # The InputObject
    [Parameter(ValueFromPipeline)]
    [PSObject]$InputObject,

    # If set, will use map the system access token to an environment variable in each script step.
    [switch]
    $UseSystemAccessToken,

    # Optional changes to a part.
    # A table of additional settings to apply wherever a part is used.
    # For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}
    [Collections.IDictionary]
    $Option,

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

    # The name of parameters that should be excluded.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ExcludeParameter,

    # The name of parameters that should be referred to uniquely.
    # For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
    # The build parameter would be foo_bar.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $UniqueParameter,

    # A collection of default parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $DefaultParameter = @{},


    # A list of build scripts.  Each build script will run as a step in the same job.
    [string[]]
    $BuildScript,

    # If set, will output the created objects instead of creating YAML.
    [switch]
    $PassThru,

    # If set, will run scripts using PowerShell core, even if on Windows.
    [switch]
    $PowerShellCore,

    # If set will run script using WindowsPowerShell if available.
    [switch]
    $WindowsPowerShell
    )

    dynamicParam {
        $myNoun = ($MyInvocation.MyCommand.Noun)
        # Create dynamic parameters for every type we can build for ADO
        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $ThingNames = $script:ComponentNames.$myNoun
        if ($ThingNames) {
            foreach ($kv in $ThingNames.GetEnumerator()) {
                $k = $kv.Key.Substring(0,1).ToUpper() + $kv.Key.Substring(1)
                $DynamicParameters.Add($k, $(& $newDynamicParameter $k $kv.Value ([string[]])))
            }
        }
        return $DynamicParameters
    }

    begin {
        $expandBuildStepCmd  = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Expand-BuildStep','Function')
        $adoOptions = @{}

        $expandADOBuildStep = @{
            BuildSystem = $myNoun
            SingleItemName = 'Trigger','Pool'
            PluralItemName = 'Steps', 'Stages','Jobs','Pipelines','Repositories', 'Schedules'
            BuildOption = $adoOptions
        }

    }

    process {
        #region Map Parameters
        $myParams = [Ordered]@{} + $PSBoundParameters
        $stepsByType = [Ordered]@{}
        $ThingNames = $script:ComponentNames.$myNoun
        foreach ($kv in $myParams.GetEnumerator()) {
            if ($ThingNames[$kv.Key]) {
                $stepsByType[$kv.Key] = $kv.Value
            } elseif ($kv.Key -eq 'InputObject') {
                if ($InputObject -is [Collections.IDictionary]) {
                    foreach ($key in $InputObject.Keys) {
                        $stepsByType[$key] = $InputObject.$key
                    }
                }
                elseif ($InputObject) {
                    foreach ($property in $InputObject.psobject.properties) {
                        $stepsByType[$property.name] = $InputObject.$key
                    }
                }
            } else {
                $adoOptions[$kv.Key] = $kv.Value
            }
        }
        #endregion Map Parameters

        if ($BuildScript) {
            $stepsByType['steps'] = 
                @(
                    Get-Item $BuildScript -ErrorAction SilentlyContinue |
                        Convert-BuildStep -BuildSystem ADOPipeline
                )
        }

        #region Expand Map
        $expandSplat = @{} + $PSBoundParameters
        foreach ($k in @($expandSplat.Keys)) {
            if (-not $expandBuildStepCmd.Parameters[$k]) {
                $expandSplat.Remove($k)
            }
        }
        $yamlToBe = Expand-BuildStep -StepMap $stepsByType @expandSplat @expandADOBuildStep

        if ($yamlToBe.parameters) {
            $yamlToBe.parameters = @($yamlToBe.parameters)
        }
        #endregion Expand Map

        if ($PassThru) {
            $yamlToBe
        } else {
            @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
        }
    }
}