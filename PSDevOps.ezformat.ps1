#requires -Module EZOut
# Install-Module EZOut or https://github.com/StartAutomating/EZOut
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="This generates format files (where its ok to Write-Host)")]
param()
$myFile = $MyInvocation.MyCommand.ScriptBlock.File
$myModuleName = $($myFile | Split-Path -Leaf) -replace '\.ezformat\.ps1', ''
$myRoot = $myFile | Split-Path


$formatting = @(
    Write-FormatView -TypeName PSDevOps.WorkItem -Action {
        $wi = $_
        $uiBuffer = $Host.UI.RawUI.BufferSize.Width - 1
        $bufferWidth = $uiBuffer
        $justify = {param($l, $r)

            $d = $bufferWidth - $l.Length - $r.Length
            $l + (' ' * $d) + $r
        }

        @(
        ('-' * $uiBuffer)
        & $justify "[$($wi.ID)] $($wi.'System.Title')" "$($wi.'System.State')"
        ('-' * $uiBuffer)
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
        ('-' * $uiBuffer)
        "$($wi.'System.Description')" -replace
            '<br(?:/)?>', [Environment]::NewLine -replace
            '</div>', [Environment]::NewLine -replace
            '<li>',"* " -replace
            '</li>', [Environment]::NewLine -replace
            '\<[^\>]+\>', '' -replace
            '&nbsp;',' ' -replace ([Environment]::NewLine * 2), [Environment]::NewLine
        ) -join [Environment]::NewLine
    }

    Write-FormatView -TypeName PSDevOps.Field -Property Name, ReferenceName, Description -AutoSize -Wrap
    Write-FormatView -TypeName PSDevOps.WorkProcess -Property Name, IsEnabled, IsDefault, Description -Wrap
)

$myFormatFile = Join-Path $myRoot "$myModuleName.format.ps1xml"
$formatting | Out-FormatData | Set-Content $myFormatFile -Encoding UTF8

$types = @(
    Write-TypeView -TypeName StartAutomating.PSDevOps.ArtifactFeed.View -AliasProperty @{
        ViewID = 'ID'
    }
    Write-TypeView -TypeName StartAutomating.PSDevOps.ArtifactFeed -AliasProperty @{
        FeedID = 'FullyQualifiedID'
    } -HideProperty ViewID
)

$myTypesFile = Join-Path $myRoot "$myModuleName.types.ps1xml"
$types | Out-TypeData | Set-Content $myTypesFile -Encoding UTF8