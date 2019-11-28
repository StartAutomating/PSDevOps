function New-GitHubAction {
    <#
    .Synopsis
        Creates a new GitHub Action
    .Description
        Create a new GitHub Action Pipeline.
    .Example
        New-GitHubAction -Stage TestPowerShellCrossPlatForm
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification = "Explicitly checking for null (0 is ok)")]
    param(
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

        if ($script:ThingNames) {
            foreach ($kv in $script:ThingNames.GetEnumerator()) {
                $k = $kv.Key.Substring(0, 1).ToUpper() + $kv.Key.Substring(1)
                $DynamicParameters.Add($k, $(& $newDynamicParameter $k $kv.Value ([string[]])))
            }
        }
        return $DynamicParameters
    }
}