function Write-ADOProgress {
    <#
    .Synopsis
        Writes AzureDevOps Progress
    .Description
        Writes a progress record to the Azure DevOps pipeline.
    .Example
        Write-ADOProgress -Activity "Doing Stuff" -Status "And Things" -PercentComplete 50
    #>
    param(
    # This text describes the activity whose progress is being reported.
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $Activity,

    # This text describes current state of the activity. 
    [Parameter(Position=1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Status,

    # Specifies an ID that distinguishes each progress bar from the others. Use this parameter when you are creating more than one progress bar in a single command.
    # If the progress bars do not have different IDs, they are superimposed instead of being displayed in a series.
    [Parameter(Position=2)]
    [ValidateRange(0, 2147483647)]
    [int]
    $Id,

    # Specifies the percentage of the activity that is completed. 
    # Use the value -1 if the percentage complete is unknown or not applicable.
    [ValidateRange(-1, 100)]
    [int]
    $PercentComplete,

    # Specifies the projected number of seconds remaining until the activity is completed.
    [int]
    $SecondsRemaining,

    # This text describes the operation that is currently taking place.
    [string]
    $CurrentOperation,

    # Specifies the parent activity of the current activity.
    [ValidateRange(-1, 2147483647)]
    [int]
    $ParentId,

    # Indicates the progress timeline operation is completed.
    [switch]
    $Completed
    )


    begin {
        if (-not $script:ADOProgressIds) {
            $script:ADOProgressIds = @{}
        }
    }

    process {
        $isFirst = $false
        if (-not $script:ADOProgressIds[$id]) {
            $script:ADOProgressIds[$id] = [GUID]::NewGuid()
            $isFirst = $true
        }
        
        if ($ParentId -and -not $script:ADOProgressIds[$ParentId]) {
            $script:ADOProgressIds[$ParentId] = [GUID]::NewGuid()
            $isFirst = $true
        }

        $properties = @(
            "id=$($script:ADOProgressIds[$ID])"
            if ($ParentId) {
                "parentid=$($script:ADOProgressIds[$id])"
            }
            if ($isFirst) {
                if ($CurrentOperation) {
                    "name=$CurrentOperation"
                } else {
                    "name=$Activity"
                }
                "type=build"
                "order=$($script:ADOProgressIds.Count)"
            }

            if ($PercentComplete -ge 0) {
                "progress=$PercentComplete"
            }

            if ($Completed) {
                "state=Completed"
                $script:ADOProgressIds.Remove($id)
            } else {
                "state=InProgress"
            }
        )

        $msg = @(
            $Activity
            '-'
            $Status
            if ($CurrentOperation) {
                "($CurrentOperation)"
            }
            if ($SecondsRemaining) {
                "(${SecondsRemaining}s remaining)"
            }
        ) -join ' '

        $out = "##vso[task.logdetail $($properties -join ';')]$msg"

        if ($env:Agent_ID -and $DebugPreference -eq 'continue') {
            Write-Host $out
        } else {
            $out
        }
    }
}