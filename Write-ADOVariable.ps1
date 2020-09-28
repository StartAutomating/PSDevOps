function Write-ADOVariable
{
    <#
    .Synopsis
        Writes an ADO Variable
    .Description
        Writes a Azure DevOps Variable.
    .Example
        Write-ADOVariable -Name Sauce -Value "Crushed Tomatoes"
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Directly outputs in certain scenarios")]
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
    $IsSecret,

    # If set, the variable will be marked as read only.
    [Alias('ReadOnly')]
    [switch]
    $IsReadOnly,

    # If set, the variable will be marked as output.  Output variables may be referenced in subsequent steps of the same job.
    [Alias('Output')]
    [switch]
    $IsOutput
    )


    process {
        #region Prepare Output
        $modifiers  = @(foreach ($pn in 'issecret', 'isreadOnly', 'isoutput') {
            if ($PSBoundParameters.$pn) {
                "$pn=true"
            }
        }) -join ';'
        $out = "##vso[task.setvariable variable=$name$(if ($modifiers) {";$modifiers"})]$Value"
        #endregion Prepare Output
        if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host -Object $out
        } else {
            $out
        }
    }
}
