function New-GitHubWorkflow {
    <#
    .Synopsis
        Creates a new GitHub Workflow
    .Example
        New-GitHubWorkflow -Job TestPowerShellOnLinux
    .Link
        Import-BuildStep
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification = "Explicitly checking for null (0 is ok)")]
    [OutputType([string])]
    param(
        # The input object.
        [Parameter(ValueFromPipeline)]
        [PSObject]$InputObject,

        # The name of the workflow.
        [string]
        $Name,

        # Optional changes to a component.
        # A table of additional settings to apply wherever a part is used.
        # For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}
        [Collections.IDictionary]
        $Option,

        # The name of parameters that should be supplied from the environment.
        # Wildcards accepted.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('EventParameters')]
        [string[]]
        $EventParameter,

        # The name of parameters that should be excluded.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('ExcludeParameters')]
        [string[]]
        $ExcludeParameter,

        # The name of parameters that should be referred to uniquely.
        # For instance, if converting function foo($bar) {} and -UniqueParameter is 'bar'
        # The build parameter would be foo_bar.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('UniqueParameters')]
        [string[]]
        $UniqueParameter,

        # A collection of default parameters.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Collections.IDictionary]
        $DefaultParameter = @{}
    )

    dynamicParam {
        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

        $ThingNames = $script:ComponentNames.'GitHub'
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

        $expandGitHubBuildStep = @{
            BuildSystem = 'GitHub'
            SingleItemName = 'On','Name'
            DictionaryItemName = 'Jobs', 'Inputs','Outputs'
        }
    }

    process {

        $myParams = [Ordered]@{ } + $PSBoundParameters

        $stepsByType = [Ordered]@{}
        if ($Name) {$stepsByType['Name'] = $name }
        #region Map Dynamic Input
        $ThingNames = $script:ComponentNames.'GitHub'
        foreach ($kv in $myParams.GetEnumerator()) {
            if ($ThingNames[$kv.Key]) {
                $stepsByType[$kv.Key] = $kv.Value
            }
        }

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
        #endregion Map Dynamic Input

        #region Expand Input
        $expandSplat = @{} + $PSBoundParameters
        foreach ($k in @($expandSplat.Keys)) {
            if (-not $expandBuildStepCmd.Parameters[$k]) {
                $expandSplat.Remove($k)
            }
        }
        #endregion Expand Input

        $yamlToBe = Expand-BuildStep -StepMap $stepsByType @expandSplat @expandGitHubBuildStep

        #$yamlToBe = & $expandComponents $stepsByType -ComponentType GitHub -SingleItemName On, Name
        @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
    }
}