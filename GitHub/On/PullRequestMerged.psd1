@{
    pull_request = @{
        branches =@('main','master')
        if = @'
${{github.event.action == 'closed' && github.event.merged == true}}
'@
        "paths-ignore" = @("docs/**","*.help.txt", "*.md")
    }
}

