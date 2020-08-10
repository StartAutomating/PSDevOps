Write-FormatView -TypeName PSDevOps.InstalledExtension -Property 'PublisherName(ID)', 'ExtensionName(ID)', Contributions -Width 20, 25 -Wrap -VirtualProperty @{
    Contributions = {
        ($_.Contributions | 
            Out-String -Width ($host.UI.RawUI.BufferSize.Width - 45)).Trim()
    }
    'PublisherName(ID)' = {
        $_.PublisherName + [Environment]::NewLine + '(' + $_.PublisherID + ')'
    }
    'ExtensionName(ID)' = {
        $_.ExtensionName + [Environment]::NewLine + '(' + $_.ExtensionID + ')'
    }
}
