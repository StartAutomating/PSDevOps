@{
    "runs-on" = "ubuntu-latest"
    steps = @('InstallPester', @{
        name = 'Check out repository'
        uses = 'actions/checkout@v2'
    },'RunPester')
}

# @{
#     job         = 'Windows'
#     displayName = 'Windows'
#     pool        = @{vmImage = 'windows-latest' }
#     steps       = 'InstallPester', 'RunPester', 'PublishTestResults', 'PublishCodeCoverage'
# }

<#
name: CI

on: [push]

jobs:
  build:

    runs-on: windows-latest

    steps:
    - run: Write-Host "Hello World"
      shell: powershell
#>