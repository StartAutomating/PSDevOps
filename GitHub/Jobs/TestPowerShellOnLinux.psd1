@{
    "runs-on" = "ubuntu-latest"
    steps = @('InstallPester', @{
        name = 'Check out repository'
        uses = 'actions/checkout@v2'
    },'RunPester')
}