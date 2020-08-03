function Write-GitHubOutput
{
    <#
    .Synopsis
        Writes GitHub Output
    .Description
        Writes formal Output to a GitHub step.

        This output can be referenced in subsequent steps.
    .Example
        Write-GitHubOutput @{
            key = 'value'
        }
    .Example
        Get-Random -Minimum 1 -Maximum 10 | Write-GitHubOutput -Name RandomNumber
    .Link
        Write-GitHubError
    #>
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "",
        Justification="Directly outputs in certain scenarios")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusableFunction", "",
        Justification="Directly outputs in certain scenarios")]
    param(
    # The InputObject.  Values will be converted to a JSON array.
    [Parameter(Mandatory,ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # The Name of the Output.  By default, 'Output'.    
    [string]
    $Name = 'Output',

    # The JSON serialization depth.  By default, 10 levels.
    [int]
    $Depth = 10
    )

    begin {
        $inQ    = [Collections.Queue]::new()
    }
    process {
        #region Output Dictionaries
        if ($InputObject -is [Collections.IDictionary]) {
            $gitOut =
                foreach ($kv in $InputObject.GetEnumerator()) {
                    "::set-output name=$($kv.Key)::$($kv.Value)"
                }

            if ($env:GITHUB_WORKFLOW -and $DebugPreference -eq 'SilentlyContinue') {
                Write-Host ($gitOut -join [Environment]::NewLine)
            } else {
                $gitOut
            }
        }
        #endregion Output Dictionaries
        #region Output Errors
        elseif ($InputObject -is [Management.Automation.ErrorRecord]) {
            $gitHubErrorParams = @{
                Message = $InputObject.Exception.Message
            }
            $stackTraceLine =
                @($InputObject.ScriptStackTrace -split 'at <ScriptBlock>,' -ne '' -match ':*line')[0]
            if ($stackTraceLine) {
                $stackTraceLineParts = @($stackTraceLine -split ':')
                $gitHubErrorParams.Line = $stackTraceLineParts[-1] -replace 'line' -replace '\s'

                $file = $stackTraceLineParts[0..($stackTraceLineParts.Count - 2)] -join ':'
                if ($file -notlike '*<*>*') {
                    $gitHubErrorParams.File = $file
                }

            }
            Write-GitHubError @gitHubErrorParams
        }
        #endregion Output Errors
        #region Output Warnings
        elseif ($InputObject -is [Management.Automation.WarningRecord])
        {
            Write-GitHubWarning -Message $InputObject.Message
        }
        #endregion Output Warnings
        #region Output Debug and Verbose
        elseif ($InputObject -is [Management.Automation.VerboseRecord] -or
            $InputObject -is [Management.Automation.DebugRecord])
        {
            Write-GitHubDebug -Message $InputObject.Message
        }
        #endregion Output Debug and Verbose
        #region Enqueue Remaining Input
        else
        {
            $inQ.Enqueue($InputObject)
        }
        #endregion Enqueue Remaining Input
    }

    end {
        $gitOut =
            if ($inQ.Count) {
                "::set-output name=$name::$($inQ.ToArray() | ConvertTo-Json -Compress -Depth $depth)"
                $inQ.Clear()
            }

        if ($gitOut) {
            if ($env:GITHUB_WORKFLOW -and $DebugPreference -eq 'SilentlyContinue') {
                Write-Host ($gitOut -join [Environment]::NewLine)
            } else {
                $gitOut
            }
        }
    }
}
