function Get-BuildStep
{
    <#
    .Synopsis
        Gets BuildSteps
    .Description
        Gets Build Steps.

        Build Steps are scripts or data fragments used to compose a build.
    .Example
        Get-BuildStep
    .Link
        Import-BuildStep
    #>
    [OutputType('PSDevOps.BuildStep')]
    param(
    # If provided, only return build steps that are like this name.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # If provided, only return build steps matching this extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Extension,

    # If provided, only return build steps of a given type.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Type,

    # If provided, only return build steps for a given build system.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $BuildSystem
    )


    process {
        #region Get Matching Build Steps
        foreach ($v in $script:ComponentMetaData.Values) {
            foreach ($val in $v.Values) {
                if ($Name -and $val.Name -notlike $name) { continue}
                if ($Extension -and $val.Extension -notlike $Extension) { continue }
                if ($Type -and $val.Type -notlike $Type) { continue }
                if ($BuildSystem -and $val.BuildSystem -notlike $BuildSystem) { continue }
                $val
            }
        }
        #region Get Matching Build Steps
    }
}
