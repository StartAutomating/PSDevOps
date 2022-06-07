function Write-GitHubDebug
{
    <#
    .Synopsis
        Writes a Git Warning
    .Description
        Writes an GitHub Workflow Warning
    .Example
        Write-GitHubDebug "Debugging"
    .Link
        Write-GitHubError
    .Link
        https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions
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
    $Message
    )

    process {

        #region Write or output the GitHub debug command.
        $out = "::debug::$Message"
        if ($env:GITHUB_WORKFLOW -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host $out
        } else {
            $out
        }
        #endregion Write or output the GitHub debug command.
    }
}
