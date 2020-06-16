{param([string]$html)
    $html -replace
    '<br(?:/)?>', [Environment]::NewLine -replace
    '</div>', [Environment]::NewLine -replace
    '<li>',"* " -replace
    '</li>', [Environment]::NewLine -replace
    '\<[^\>]+\>', '' -replace
    '&quot;', '"' -replace 
    '&nbsp;',' ' -replace ([Environment]::NewLine * 2), [Environment]::NewLine
}
