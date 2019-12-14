@{
  build = @{
    "runs-on" = "ubuntu-latest"
  }

  steps = 'PSCore'
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