function Trace-ADOOutput
{
    <#
    .Synopsis
        Traces information into Azure DevOps Output
    .Description
        Traces information about a command into the output of Azure DevOps.
    .Example
        Trace-ADOOutput -Command Get-Process -Parameter @{id=$pid}
    .Example
        $myInvocation | Trace-ADOOutput
    .Link
        Write-ADOOutput
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
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
            #region Write Command Message
            $message = (
                '##[command]' + $Command + ' ' + @(
                    if ($Parameter) {
                        foreach ($kv in $Parameter.GetEnumerator()) {
                            '-' + $kv.Key
                            $kv.Value
                        }
                    }
                ) -join ' '
            )

            if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
                Write-Host -Object $message
            } else {
                $message
            }
            #endregion Write Command Message
        }
    }
}
