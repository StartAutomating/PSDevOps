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
    .Link
        Write-GitHubError
    #>
    param(
    # The InputObject.  Values will be converted to a JSON array.
    [Parameter(Mandatory,ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # The Name of the Output.  By default, 'Output'.
    [Parameter()]
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
        #region Enqueue Input
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
        } else {
            $inQ.Enqueue($InputObject)
        }
        #endregion Enqueue Input
    }

    end {
        $gitOut = 
            if ($inQ.Count) {
                "::set-output name=$name::$($inQ.ToArray() | ConvertTo-Json -Compress -Depth $depth)"
                $inQ.Clear()
            }

        if ($env:GITHUB_WORKFLOW -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host ($gitOut -join [Environment]::NewLine)
        } else {
            $gitOut
        }
    }
}
