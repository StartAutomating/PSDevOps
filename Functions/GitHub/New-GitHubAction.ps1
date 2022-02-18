function New-GitHubAction {
    <#
    .Synopsis
        Creates a new GitHub action
    .Example
        
        New-GitHubAction -Job TestPowerShellOnLinux
    .Link
        New-GitHubWorkflow
    .Link
        Import-BuildStep
    .Link
        Convert-BuildStep
    .Link
        Expand-BuildStep
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification = "Explicitly checking for null (0 is ok)")]
    [OutputType([string])]
    param(
        # The name of the action.
        [Parameter(Mandatory,Position=0)]
        [string]
        $Name,

        # A description of the action.
        [Parameter(Mandatory,Position=0)]
        [string]
        $Description,

        # The git hub action steps.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Management.Automation.ArgumentCompleter({
            # While we don't want to restrict the steps here, we _do_ want to be able to suggest steps that are built-in.
            $psDevOpsModule = Get-Module PSDevOps
            if ($psDevOpsModule) {
                & $psDevOpsModule {
                    $script:ComponentMetaData.GitHubAction.Values | 
                        Where-Object Type -eq Action |
                        Select-object -ExpandProperty Name 
                }
            }
        })]
        [PSObject[]]$Action,

        # The DockerImage used for a GitHub Action.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DockerImage,

        # The NodeJS main script used for a GitHub Action.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$NodeJSScript,

        # The git hub action inputs.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Collections.IDictionary]$ActionInput,

        # The git hub action outputs.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Collections.IDictionary]$ActionOutput,

        # Optional changes to a component.
        # A table of additional settings to apply wherever a part is used.
        # For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}
        [Collections.IDictionary]
        $Option,

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

        # A list of build scripts.  Each build script will run as a step in the action.
        [string[]]
        $BuildScript,

        # The icon used for branding.  By default, a terminal icon.
        [string]
        $Icon = "terminal",

        # The color used for branding.  By default, blue.
        [ValidateSet('white', 'yellow', 'blue', 'green', 'orange', 'red', 'purple', 'gray-dark')]
        [string]
        $Color = 'blue'
    )   

    begin {
        
        $expandBuildStepCmd  = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Expand-BuildStep','Function')        
        $workflowOptions = @{}
        $mynoun = "GitHubAction"
        $expandGitHubBuildStep = @{
            BuildSystem = $mynoun
            SingleItemName = 'On','Name'
            DictionaryItemName = 'Jobs', 'Inputs','Outputs'
            BuildOption = $workflowOptions
        }
        $DoNotExpandParameters = 'InputObject', 'BuildScript', 'DockerImage', 'NodeJSScript', 'Icon', 'Color', 'ActionInput', 'ActionOutput'
    }

    process {

        $myParams = [Ordered]@{ } + $PSBoundParameters

        $stepsByType = [Ordered]@{
            Name = $Name
            Description = $Description
        }
                
        
        $ThingNames = $script:ComponentNames.$mynoun
        foreach ($kv in $myParams.GetEnumerator()) {
            if ($ThingNames[$kv.Key]) {
                $stepsByType[$kv.Key] = $kv.Value
            } elseif ($DoNotExpandParameters -notcontains $kv.Key) {
                $workflowOptions[$kv.Key] = $kv.Value
            }
        }

        
        #region Map InputObject
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

        $stepsByType["branding"] = [Ordered]@{
            icon = $Icon
            color = $Color
        }

        #endregion Map InputObject

        #region Expand Input
        $expandSplat = @{} + $PSBoundParameters
        foreach ($k in @($expandSplat.Keys)) {
            if (-not $expandBuildStepCmd.Parameters[$k]) {
                $expandSplat.Remove($k)
            }
        }

        if ($ActionInput) {
            $stepsByType.inputs = $ActionInput
        }
        if ($ActionOutput) {
            $stepsByType.outputs = $ActionOutput
        }


        #endregion Expand Input
        $yamlToBe = Expand-BuildStep -StepMap $stepsByType @expandSplat @expandGitHubBuildStep -InputParameter @{'*'='*'}
        if ($yamlToBe.actions.run) {
            $actionSteps = $yamlToBe.actions
            $yamlToBe.runs = [Ordered]@{
                using = "composite"
                steps = @($actionSteps)
            }
            $yamlToBe.Remove('actions')            
        }
        elseif ($DockerImage) {
            $yamlToBe.runs = [Ordered]@{
                using = "docker"
                image = $DockerImage 
            }
        } 
        elseif ($NodeJSScript) {
            $yamlToBe.runs = [Ordered]@{
                using = "node12"
                main = $NodeJSScript
            }
        }

        $yamlToBe.Remove('On')

        
        
        if ($BuildScript) {
            if (-not $yamlToBe.steps) {
                $yamlToBe.steps = [Ordered]@{}
            }
            $yamlToBe.steps = [Ordered]@{
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
            @($yamlToBe | & $toYaml -Indent -2) -join '' -replace 
                "$([Environment]::NewLine * 2)", [Environment]::NewLine
        }
    }
}
