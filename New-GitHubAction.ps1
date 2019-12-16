function New-GitHubAction {
    <#
    .Synopsis
        Creates a new GitHub Action Pipeline
    .Example
        New-GitHubAction -Step InstallPester
    #>

    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification = "Explicitly checking for null (0 is ok)")]
    param(
        # The input object.
        [Parameter(ValueFromPipeline)]
        [PSObject]$InputObject,

        
        # Optional changes to a component.
        # A table of additional settings to apply wherever a part is used.
        # For example -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}
        [Collections.IDictionary]
        $Option
    )

    dynamicParam {

        $newDynamicParameter = {
            param([string]$name, [string[]]$ValidSet, [type]$type = [string], [string]$ParameterSet = '__AllParameterSets', [switch]$Mandatory)

            $ParamAttr = [Management.Automation.ParameterAttribute]::new()
            $ParamAttr.Mandatory = $Mandatory
            $ParamAttr.ParameterSetName = $ParameterSet
            $ParamAttributes = [Collections.ObjectModel.Collection[System.Attribute]]::new()
            $ParamAttributes.Add($ParamAttr)

            if ($ValidSet) {
                $ParamAttributes.Add([Management.Automation.ValidateSetAttribute]::new($ValidSet))
            }

            [Management.Automation.RuntimeDefinedParameter]::new($name, $type, $ParamAttributes)
        }

        $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

        $ThingNames = $script:ComponentNames.'GitHubActions'
        if ($ThingNames) {
            foreach ($kv in $ThingNames.GetEnumerator()) {
                $k = $kv.Key.Substring(0,1).ToUpper() + $kv.Key.Substring(1)
                $DynamicParameters.Add($k, $(& $newDynamicParameter $k $kv.Value ([string[]])))
            }
        }

        return $DynamicParameters
    }

    process {

        $myParams = [Ordered]@{ } + $PSBoundParameters

        $stepsByType = [Ordered]@{ }
        $ThingNames = $script:ComponentNames.'GitHubActions'
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

        $yamlToBe = & $expandComponents $stepsByType -ComponentType GitHubActions -SingleItemName On, Name
        @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
    }
}