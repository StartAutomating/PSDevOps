@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'            
        }, 'RunEZOut', @{
            name = 'Push Changes'
            shell = 'pwsh'
            run   = 'git push; exit 0'
        }
    )
}



