function Set-ADOVariable
{
    <#
    .Synopsis
        Sets an ADO Variable
    .Description
        Sets a Azure DevOps Variable
    .Example
        Set-ADOVariable -Name Sauce -Value "Crushed Tomatoes"
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Directly outputs in certain scenarios")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Confirmation would be impossible within host")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusableFunction", "", Justification="Directly outputs in certain scenarios")]
    [OutputType([string])]
    param(
    # The variable name.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The variable value.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $Value,

    # If set, the variable will be a secret.  Secret variables will not echo in logs.
    [Alias('IsSafe','Secret')]
    [switch]
    $IsSecret
    )


    process {
        #region Prepare Output
        $out = "##vso[task.setvariable variable=$Name$(if ($IsSecret) {";issecret=true"})]$Value"
        #endregion Prepare Output
        if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host -Object $out
        } else {
            $out
        }
    }
}
