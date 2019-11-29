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
        if ($wi.'System.AssignedTo') {
            & $justify "Assigned To:" $wi.'System.AssignedTo'.displayName
        }
        if ($wi.'System.IterationPath') {
            & $justify "Iteration Path:" $wi.'System.IterationPath'
        }
        & $justify "Last Updated:" "$($wi.'System.ChangedBy'.displayName) @ $($wi.'System.ChangedDate' -as [DateTime])"
        & $justify "Created:" "$($wi.'System.CreatedBy'.displayName) @ $($wi.'System.CreatedDate' -as [DateTime])"
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
)

$myFormatFile = Join-Path $myRoot "$myModuleName.format.ps1xml"
$formatting | Out-FormatData | Set-Content $myFormatFile -Encoding UTF8