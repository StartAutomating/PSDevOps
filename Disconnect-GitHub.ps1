function Disconnect-GitHub
{
    <#
    .Synopsis
        Disconnects from GitHub
    .Description
        Disconnects from GitHub.

        This unloads any dynamically imported commands and clears the cached PersonalAccessToken.
    .Example
        Disconnect-GitHub
    .Link
        Connect-GitHub
    #>

    param()

    begin {
        $dynamicModuleName = "PSDevOps.DynamicGitHub"
    }

    process {
        $script:CachedGitPAT = ''

        $loadedModuleNames = Get-Module | Select-Object -ExpandProperty Name
        if ($loadedModuleNames -contains $dynamicModuleName) {
            Remove-Module $dynamicModuleName
        }

        foreach ($k in @($global:PSDefaultParameterValues.Keys)) {
            if ($k -like "*github*") { $global:PSDefaultParameterValues.Remove($k) }
        }
    }
}
