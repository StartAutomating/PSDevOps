$virtualProperties = @{
    Author = { $_.Author.DisplayName }
    Timestamp = {
        ([DateTime]$_.TimeStamp).ToLocalTime().ToString()
    }
}
Write-FormatView -TypeName StartAutomating.PSDevOps.Build.Change -Property Author, Timestamp, Message -VirtualProperty $virtualProperties -Wrap

Write-FormatView -TypeName StartAutomating.PSDevOps.Build.Change -Property Author, Timestamp, Message, Type, DisplayUri -AsList -VirtualProperty $virtualProperties
