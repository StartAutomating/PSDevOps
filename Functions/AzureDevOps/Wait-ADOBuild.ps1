function Wait-ADOBuild
{
    <#
    .Synopsis
        Waits for Azure DevOps Builds
    .Description
        Waits for Azure DevOps or TFS Builds to complete, fail, get cancelled, or be postponed.
    .Example
        Get-ADOBuild -Organization MyOrg -Project MyProject -First 1 |
            Wait-ADOBuild
    .Link
        Get-ADOBuild
    .Link
        Start-ADOBuild
    #>
    [OutputType('PSDevOps.Build')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # One or more build IDs.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string[]]
    $BuildID,

    # The server.  By default https://dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    [string]
    $ApiVersion = "5.1",

    # The time to wait before each retry.  By default, 3 1/3 seconds.
    [TimeSpan]
    $PollingInterval = '00:00:03.33',

    # The timeout.  If provided, the function will wait no longer than the timeout.
    [TimeSpan]
    $Timeout
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q = [Collections.Queue]::new()
    }

    process {
        foreach ($bldId in $BuildID) {
            $in = @{} + $PSBoundParameters
            $in.BuildID = $bldId
            $q.Enqueue([PSCustomObject]$in)
        }
    }

    end {
        $progId   = Get-Random
        $progress = 0
        $qArray   = $q.ToArray()
        $t = $qArray.Length
        $startAt  = [DateTime]::Now
        while ($qArray) {
            $finished = @()
            $qArray = @(
                $qArray |
                    Get-ADOBuild @invokeParams |
                    ForEach-Object {
                        if ($_.Status -in 'completed', 'failed', 'cancelling','postponed') {
                            $finished += $_
                        } else {
                            $_
                        }
                    }
            )
            $c = $t - $qArray.Length
            if ($qArray -and $PollingInterval.TotalMilliseconds -ge 0) {
                $waitingFor = $(@($qArray | ForEach-Object {$_.Definition.Name} ) -join ',')
                if ($Timeout -and (([DateTime]::Now - $startAt) -ge $Timeout)) {
                    Write-Warning "Timed out after $($Timeout).  Waiting for $waitingFor"
                    return
                }

                Write-Progress "Waiting For Builds: $waitingFor" "[$c/$t]" -PercentComplete $progress -Id $progId
                $progress += 5
                if ($progress -gt 100) { $progress = 5 }

                Start-Sleep -Milliseconds $PollingInterval.TotalMilliseconds
            }

            $finished
        }

        Write-Progress "Waiting For Builds" "[$c/$t]" -Completed -Id $progId
    }
}
