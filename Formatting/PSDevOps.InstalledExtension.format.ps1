Write-FormatView -TypeName PSDevOps.InstalledExtension -Property 'PublisherName(ID)', 'ExtensionName(ID)', Version, Contributions -Wrap -Width 20, 20, 20 -VirtualProperty @{
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
