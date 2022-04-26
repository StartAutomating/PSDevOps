@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
            with = @{
                repository = '${{ github.repository }}.wiki'
                path = 'wiki'
                persistCredentials = $true
            }
            
        },
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
            persistCredentials = $true
        }      
        'RunHelpOut'
    )
}



