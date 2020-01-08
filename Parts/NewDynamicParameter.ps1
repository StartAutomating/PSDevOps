param(
    [string]$name,
    [string[]]$ValidSet,
    [type]$type = [string],
    [string]$ParameterSet = '__AllParameterSets',
    [switch]$Mandatory
)

$ParamAttr = [Management.Automation.ParameterAttribute]::new()
$ParamAttr.Mandatory = $Mandatory
$ParamAttr.ParameterSetName = $ParameterSet

$ParamAttributes = [Collections.ObjectModel.Collection[System.Attribute]]::new()
$ParamAttributes.Add($ParamAttr)

if ($ValidSet) {
    $ParamAttributes.Add([Management.Automation.ValidateSetAttribute]::new($ValidSet))
}

return [Management.Automation.RuntimeDefinedParameter]::new($name,  $type, $ParamAttributes)
