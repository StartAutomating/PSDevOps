Write-FormatView -TypeName 'PSDevOps.WorkItem' -Property ID, AssignedTo, Title  -VirtualProperty @{
    AssignedTo = { if ($_.AssignedTo.DisplayName) { $_.AssignedTo.DisplayName } else { $_.AssignedTo } } 
} -Width 8, 20 -Wrap


Write-FormatView -TypeName 'PSDevOps.WorkItem' -Action {
$wi = $_
$uiBuffer = $Host.UI.RawUI.BufferSize.Width - 1
$bufferWidth = $uiBuffer
$justify = {param($l, $r)
    
    $d = $host.UI.RawUI.BufferSize.Width - 1 - $l.Length - $r.Length
    if ($d -lt 0) { $d = 0 }
    $l + (' ' * $d) + $r
            
}

@(
. $HorizontalRule
#('-' * $uiBuffer)
& $justify "[$($wi.ID)] $($wi.'System.Title')" "$($wi.'System.State')"
. $HorizontalRule
#('-' * $uiBuffer)
if ($wi.'System.IterationPath') {
    & $justify "Iteration Path:" $wi.'System.IterationPath'
}
if ($wi.'System.AssignedTo') {
    & $justify "Assigned To:" $(if ($wi.'System.AssignedTo'.displayName) {
        $wi.'System.AssignedTo'.displayName
    } else {
        $wi.'System.AssignedTo'
    })
}
$changedBy =
    if ($wi.'System.ChangedBy'.displayName) {
        $wi.'System.ChangedBy'.displayName
    } elseif ($wi.'System.ChangedBy') {
        $wi.'System.ChangedBy'
    }
if ($changedBy) {
    & $justify "Last Updated:" "$changedBy @ $($wi.'System.ChangedDate' -as [DateTime])"
}
$createdBy =
    if ($wi.'System.CreatedBy'.displayName) {
        $wi.'System.CreatedBy'.displayName
    } elseif ($wi.'System.CreatedBy') {
        $wi.'System.CreatedBy'
    }
if ($createdby) {
    & $justify "Created:" "$createdBy @ $($wi.'System.CreatedDate' -as [DateTime])"
}
if ($wi.'System.Description') {
    "Description:"
    . $horizontalRule -Character '_'
    $wi.HTMLToText("$($wi.'System.Description')")
    . $horizontalRule -Character '_'
}

if ($wi.'Microsoft.VSTS.TCM.ReproSteps') {
    "Repro Steps:"
    . $horizontalRule -Character '_'
    [Environment]::NewLine
    $wi.HTMLToText("$($wi.'Microsoft.VSTS.TCM.ReproSteps')")
    . $horizontalRule -Character '_'
    [Environment]::NewLine
}




        
) -join [Environment]::NewLine
}