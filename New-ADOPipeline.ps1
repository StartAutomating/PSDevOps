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
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for null (0 is ok)")]
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

    # The name of parameters that should be referred to uniquely.
    # For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
    # The build parameter would be foo_bar.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $UniqueParameter,

    # A collection of default parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $DefaultParameter = @{})

    dynamicParam {
        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $ThingNames = $script:ComponentNames.'ADO'
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

        $expandADOBuildStep = @{
            BuildSystem = 'ADO'
            SingleItemName = 'Trigger','Pool'
            PluralItemName = 'Steps', 'Stages','Jobs','Pipelines','Repositories', 'Schedules'
        }

    }

    process {
        $myParams = [Ordered]@{} + $PSBoundParameters
        $stepsByType = [Ordered]@{}
        $ThingNames = $script:ComponentNames.'ADO'
        foreach ($kv in $PSBoundParameters.GetEnumerator()) {
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
            }
        }

        $expandSplat = @{} + $PSBoundParameters
        foreach ($k in @($expandSplat.Keys)) {
            if (-not $expandBuildStepCmd.Parameters[$k]) {
                $expandSplat.Remove($k)
            }
        }
        $yamlToBe = Expand-BuildStep -StepMap $stepsByType @expandSplat @expandADOBuildStep #> -SingleItemName Trigger, Pool -BuildSystem ADO 

        #$yamlToBe = & $ExpandComponents $stepsByType -SingleItemName Trigger, Pool -ComponentType ADO


        @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
    }
}