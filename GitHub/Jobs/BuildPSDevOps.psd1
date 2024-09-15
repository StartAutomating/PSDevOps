@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v4'
        },
        'RunPSSVG',
        'RunPipeScript',
        'RunEZOut',       
        'RunHelpOut'
    )
}