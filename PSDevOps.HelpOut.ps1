$PSDevOpsLoaded = Get-Module PSDevOps
if (-not $PSDevOpsLoaded) {
    $PSDevOpsLoaded = Get-ChildItem -Recurse -Filter "*.psd1" | Where-Object Name -like 'PSDevOps*' | Import-Module -Name { $_.FullName } -Force -PassThru
}
if ($PSDevOpsLoaded) {
    "::notice title=ModuleLoaded::PSDevOps Loaded" | Out-Host
} else {
    "::error:: PSDevOps not loaded" |Out-Host
}
if ($PSDevOpsLoaded) {
    Save-MarkdownHelp -Module $PSDevOpsLoaded.Name -PassThru
}
