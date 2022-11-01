@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        }, 
        'RunPipeScript',
        'RunEZOut',        
        'RunHelpOut'
    )
}




