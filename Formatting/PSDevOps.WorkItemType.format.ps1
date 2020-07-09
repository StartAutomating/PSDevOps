Write-FormatView -TypeName PSDevOps.WorkItemType -Property Name, Icon, Color, Description -Wrap -VirtualProperty @{
    Icon = {
        if ($_.Icon.id) {
            $_.Icon.id
        } else {
            $_.Icon
        }
    }
}
