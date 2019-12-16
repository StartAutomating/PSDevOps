param(
    [Parameter(Mandatory,Position=0)]
    [string]
    $ModuleName
)

$loadedModules = Get-Module

foreach ($module in $loadedModules) {
    $requiredModuleNames = @(foreach ($_ in $module.RequiredModules) {$_.Name })
    if ($requiredModuleNames -notcontains $ModuleName -and
        $module.PrivateData.PSData.Tags -notcontains $ModuleName) { continue }
    $module
}