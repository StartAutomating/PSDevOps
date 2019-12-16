function New-ADOPipeline
{
    <#
    .Synopsis
        Creates a new ADO Pipeline
    .Description
        Create a new Azure DevOps Pipeline.
    .Example
        New-ADOPipeline -Stage PowerShellStaticAnalysis,TestPowerShellCrossPlatForm, UpdatePowerShellGallery
    .Example
        New-ADOPipeline -Stage PowerShellStaticAnalysis,TestPowerShellCrossPlatForm, UpdatePowerShellGallery -Option @{RunPester=@{env=@{"SYSTEM_ACCESSTOKEN"='$(System.AccessToken)'}}}
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
    $Option)

    dynamicParam {
        $newDynamicParameter = {
            param([string]$name, [string[]]$ValidSet, [type]$type = [string],[string]$ParameterSet = '__AllParameterSets', [switch]$Mandatory)

            $ParamAttr = [Management.Automation.ParameterAttribute]::new()
            $ParamAttr.Mandatory = $Mandatory
            $ParamAttr.ParameterSetName = $ParameterSet

            $ParamAttributes = [Collections.ObjectModel.Collection[System.Attribute]]::new()
            $ParamAttributes.Add($ParamAttr)

            if ($ValidSet) {
                $ParamAttributes.Add([Management.Automation.ValidateSetAttribute]::new($ValidSet))
            }

            [Management.Automation.RuntimeDefinedParameter]::new($name,  $type, $ParamAttributes)
        }

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

    process {
        $myParams = [Ordered]@{} + $PSBoundParameters
        $stepsByType = [Ordered]@{}
        $ThingNames = $script:ComponentNames.'ADO'
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

        $yamlToBe = & $ExpandComponents $stepsByType -SingleItemName Trigger -ComponentType ADO


        @($yamlToBe | & $toYaml -Indent -2) -join '' -replace "$([Environment]::NewLine * 2)", [Environment]::NewLine
    }
}