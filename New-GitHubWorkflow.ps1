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

        # A collection of environment variables used throughout the build.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Env')]
        [Collections.IDictionary]
        $Environment,

        # The name of parameters that should be supplied from an event.
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
        $DefaultParameter = @{},

        # If set, will output the created objects instead of creating YAML.
        [switch]
        $PassThru,

        # A list of build scripts.  Each build script will run as a step in the same job.
        [string[]]
        $BuildScript,

        [string]
        $RootDirectory
    )

    dynamicParam {
        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $mynoun = $MyInvocation.MyCommand.Noun
        $ThingNames = $script:ComponentNames.$mynoun
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
        $workflowOptions = @{}
        $expandGitHubBuildStep = @{
            BuildSystem = $mynoun
            SingleItemName = 'Name','On'
            DictionaryItemName = 'Jobs', 'Inputs','Outputs'
            BuildOption = $workflowOptions
        }
        $DoNotExpandParameters = 'InputObject', 'BuildScript', 'RootDirectory'
    }

    process {

        $myParams = [Ordered]@{ } + $PSBoundParameters

        $stepsByType = [Ordered]@{}
        if ($Name) {$stepsByType['Name'] = $name }
        #region Map Dynamic Input
        $ThingNames = $script:ComponentNames.$mynoun
        foreach ($kv in $myParams.GetEnumerator()) {
            if ($ThingNames[$kv.Key]) {
                $stepsByType[$kv.Key] = $kv.Value
            } elseif ($DoNotExpandParameters -notcontains $kv.Key) {
                $workflowOptions[$kv.Key] = $kv.Value
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

        if ($RootDirectory) { $workflowOptions.RootDirectory = $RootDirectory}

        #region Expand Input
        $expandSplat = @{} + $PSBoundParameters
        foreach ($k in @($expandSplat.Keys)) {
            if (-not $expandBuildStepCmd.Parameters[$k]) {
                $expandSplat.Remove($k)
            }
        }
        #endregion Expand Input
        $yamlToBe = Expand-BuildStep -StepMap $stepsByType @expandSplat @expandGitHubBuildStep

        if ($BuildScript) {
            if (-not $RootDirectory) { $RootDirectory = "$pwd" } 
            if (-not $yamlToBe.jobs) {
                $yamlToBe.jobs = [Ordered]@{}
            }
            $yamlToBe.jobs.Build = [Ordered]@{
                steps = @(
                    Get-Item $BuildScript -ErrorAction SilentlyContinue |
                        Convert-BuildStep -BuildSystem GitHubWorkflow
                )
            }
        }

        if ($Environment) {
            if (-not $yamlToBe.env) {
                $yamlToBe.env = [Ordered]@{}
            }
            foreach ($kv in $Environment.GetEnumerator()) {
                $yamlToBe.env[$kv.Key] = $kv.Value
            }
        }

        if ($PassThru) {
            $yamlToBe
        } else {
            @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
        }
    }
}