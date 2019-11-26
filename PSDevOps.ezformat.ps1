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
        $bufferWidth = $uiBuffer - 2
        $titleLineStart = $wi.'System.Title'
        $titleLineEnd = "$($wi.'System.State') [$($wi.ID)]"
        $titleMiddleSpace  = $bufferWidth - $titleLineStart.Length -  $titleLineEnd.Length

        $changedBy   = "$($wi.'System.ChangedBy'.displayName)"
        $changedDate = "$($wi.'System.ChangedDate' -as [DateTime])"
        $changedLine = 'Last Updated' + (' ' *
            ($uiBuffer - "Last Updated".Length - "$changedBy @ $changedDate".Length)
        ) + "$changedBy @ $changedDate"

        $createdBy   = "$($wi.'System.CreatedBy'.displayName)"
        $createdDate = "$($wi.'System.CreatedDate' -as [DateTime])"
        $createdLine = 'Created' + (' ' *
            ($uiBuffer - "Created".Length - "$createdBy @ $createdDate".Length)
        ) + "$createdBy @ $createdDate"


        $lines = @(
            ('-' * $uiBuffer)
            "$titleLineStart $(' ' * $titleMiddleSpace) $titleLineEnd"
            ('-' * $uiBuffer)
            $changedLine
            $createdLine
            ('-' * $uiBuffer)
            "$($wi.'System.Description')" -replace
                '<br(?:/)?>', [Environment]::NewLine -replace
                '</div>', [Environment]::NewLine -replace
                '<li>',"* " -replace
                '</li>', [Environment]::NewLine -replace
                '\<[^\>]+\>', '' -replace
                '&nbsp;',' ' -replace ([Environment]::NewLine * 2), [Environment]::NewLine
        )

        $lines -join [Environment]::NewLine
    }

    Write-FormatView -TypeName PSDevOps.Field -Property Name, ReferenceName, Description -AutoSize -Wrap
)

$myFormatFile = Join-Path $myRoot "$myModuleName.format.ps1xml"
$formatting | Out-FormatData | Set-Content $myFormatFile -Encoding UTF8