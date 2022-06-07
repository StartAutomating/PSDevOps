function Write-ADODebug
{
    <#
    .Synopsis
        Writes an ADO Debug
    .Description
        Writes an Azure DevOps Debug
    .Example
        Write-ADODebug "Some extra information"
    .Link
        Write-ADOError
    .Link
        Write-ADOWarning
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
    #>
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "",
        Justification="Directly outputs in certain scenarios")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusableFunction", "",
        Justification="Directly outputs in certain scenarios")]
    param(
    # The Debug message.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Message)

    process {
        #region Collect Optional Properties
        #endregion Collect Optional Properties
        # Then output the Debug with it's message.
        $out = "##[debug]$Message"
        if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host $out
        } else {
            $out
        }
    }
}