Write-FormatView -TypeName PSDevOps.SecurityNamespace -Property Name, NamespaceID, Permissions -Wrap -VirtualProperty @{
    Permissions = { $_.Permissions -join [Environment]::NewLine }
}