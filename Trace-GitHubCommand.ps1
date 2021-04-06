function Trace-GitHubCommand
{
    <#
    .Synopsis
        Traces information into GitHub Workflow Output
    .Description
        Traces information about a command as a debug message in a GitHub workflow.
    .Example
        Trace-GitHubCommand -Command Get-Process -Parameter @{id=$pid}
    .Example
        $myInvocation | Trace-GitHubCommand
    .Link
        Write-GitDebug
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Directly outputs in certain scenarios")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusableFunction", "", Justification="Directly outputs in certain scenarios")]
    [OutputType([string])]
    param(
    # The command line.
    [Parameter(Mandatory,ParameterSetName='Command',ValueFromPipelineByPropertyName)]
    [Alias('MyCommand','Line')]
    [string]
    $Command,

    # A dictionary of parameters to the command.
    [Parameter(ParameterSetName='Command',ValueFromPipelineByPropertyName)]
    [Alias('Parameters', 'BoundParameters')]
    [Collections.IDictionary]
    $Parameter
    )

    process {
        if ($Command) {
            #region Write Debug Message
            Write-GitHubDebug -Message  (
                $Command + ' ' + @(
                    if ($Parameter) {
                        foreach ($kv in $Parameter.GetEnumerator()) {
                            '-' + $kv.Key
                            $kv.Value
                        }
                    }
                ) -join ' '
            )
            #endregion Write Debug Message
        }
    }
}
