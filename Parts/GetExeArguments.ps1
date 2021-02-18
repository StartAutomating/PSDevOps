<#
.Synopsis
    Converts Parameters and Command Metadata to executable arguments
.Description
    Converts a Parameter dictionary and Command Metadata into executable arguments.
#>
param(
[Parameter(Mandatory)]
[Management.Automation.CommandMetaData]
$CommandMetaData,

[Parameter(Mandatory)]
[Collections.IDictionary]
$Parameter = @{},

[string[]]
$ArgumentList = @(),

[string[]]
$AdditionalArgument = @()
)

$ArgumentList + @(   
    foreach ($kv in $Parameter.GetEnumerator()) {
        $paramMetadata = $CommandMetaData.Parameters[$kv.Key]
        if (-not $paramMetadata) { continue }
        if (-not $paramMetadata.Aliases) { continue } 
        if ($paramMetadata.Aliases[0] -match '[-/]') {
            if ($paramMetadata.Aliases[0] -match '\=$') {
                $paramMetadata.Aliases[0] + "$($kv.Value)"
            } else {
                $paramMetadata.Aliases[0]
                if ($paramMetadata.ParameterType -ne [switch]) {
                    "$($kv.Value)"
                }
            }
        }
        elseif ($paramMetadata.Aliases[0] -match '\<\w+\>' ) {
            foreach ($v in $kv.Value) { "$v" }
        }
        elseif (-not ($paramMetadata.Aliases -match '^\!')) {
            foreach ($v in $kv.Value) { "$v" }
        }
    }
) + $AdditionalArgument


