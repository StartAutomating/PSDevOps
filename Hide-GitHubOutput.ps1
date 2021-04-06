function Hide-GitHubOutput
{
    <#
    .Synopsis
        Masks output
    .Description
        Prevents a message from being printed in a GitHub Workflow log.
    .Example
        Hide-GitHubOutput 'IsItSecret?'
        'IsItSecret?' | Out-Host
    .Link
        Write-GitHubOutput
    .Link
        https://docs.github.com/en/actions/reference/workflow-commands-for-GitHubhub-actions
    #>
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "",
        Justification="Directly outputs in certain scenarios")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusableFunction", "",
        Justification="Directly outputs in certain scenarios")]
    param(
    # The message to hide.  Any time this string would appear in logs, it will be replaced by asteriks.
    [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
    [string]
    $Message
    )

    process {
        #region Write or output the GitHub add-mask command.
        $out = "::add-mask::$Message"
        if ($env:GITHUB_WORKFLOW -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host $out
        } else {
            $out
        }
        #endregion Write or output the GitHub add-mask command.
    }
}
