function Connect-GitHub
{
    <#
    .Synopsis
        Connects to GitHub
    .Description
        Connects to GitHub, automatically creating smart aliases for all GitHub URLs.
    .Example
        Connect-GitHub
    .Link
        Invoke-GitHubRESTAPI
    #>
    param(
    # A URL that contains the GitHub OpenAPI definition
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $GitHubOpenAPIUrl = 'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json',

    # If set, will output the dynamically imported module.
    [switch]
    $PassThru,

    # If set, will force a reload of the module.
    [switch]
    $Force,

    # The personal access token used to connect to GitHub.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PersonalAccessToken,

    # If provided, will default the [owner] in GitHub API requests
    [string]
    $Owner,

    # If provided, will default the [username] in GitHub API requests
    [string]
    $UserName,

    # If provided, will default the [repo] in GitHub API requests
    [string]
    $Repo
    )

    begin {
        $dynamicModuleName = "PSDevOps.DynamicGitHub"
        $myModuleCommands =
            @(if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                  $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands.Values
                  $MyInvocation.MyCommand.ScriptBlock.Module.ExportedAliases.Values
            })
    }

    process {
        if ($PersonalAccessToken) {
            $script:CachedGitPAT = $PersonalAccessToken
        }

        $loadedModuleNames = Get-Module | Select-Object -ExpandProperty Name

        if ($loadedModuleNames -contains $dynamicModuleName) {
            if (-not $Force) {
                Write-Verbose "$dynamicModuleName already loaed"
                return
            }
            else {
                Get-Module $dynamicModuleName | Remove-Module
            }
        }


        $GitHubOpenAPI = Invoke-RestMethod -Uri $GitHubOpenAPIUrl
        if (-not $GitHubOpenAPI) {
            return
        }

        $rootUrl = [uri]($GitHubOpenAPI.servers | Select-Object -First 1 -ExpandProperty URL)
        $dynamicModuleContent = @(foreach ($path in $GitHubOpenAPI.paths.psobject.properties) {
            $aliasName = $rootUrl.host + $path.Name -replace '{', '<' -replace '}','>'
            "Set-Alias '$AliasName' Invoke-GitHubRESTApi"
        }) -join [Environment]::NewLine

        $dynamicModuleContent += ";Export-ModuleMember -Alias *"

        #region Create and import module
        $dynamicModule = New-Module -Name $dynamicModuleName -ScriptBlock ([ScriptBlock]::Create($dynamicModuleContent)) 
        
        $dynamicModule| Import-Module -Global -PassThru:$passThru
        #endregion Create and import module

        $toCache = [Ordered]@{} + $PSBoundParameters
        $toCache.Remove('PersonalAccessToken')
        $toCache.Remove('PassThru')
        $toCache.Remove('Force')

        $myModuleCommands += $dynamicModule.ExportedAliases.Values

        foreach ($cmd in $myModuleCommands) {
            if ($cmd.Name -notlike '*GitHub*') { continue } # If its not an GitHub command, skip it.
            # Walk over each parameter we're caching.
            foreach ($kv in $toCache.GetEnumerator()) {
                $paramExists = $cmd.Parameters.($kv.Key) # Check to see if the parameter exists
                if (-not $paramExists) { # if it didn't, check the aliases.
                    foreach ($v in $cmd.Parameters.Values) {
                        if ($v.Aliases -contains $kv.Key) {
                            $paramExists = $cmd.Parameters.($v.Name)
                        }
                    }
                }
                if ($paramExists) { # If the parameter existed, set $global:PSDefaultParameterValues
                    $global:PSDefaultParameterValues["${cmd}:$($kv.Key)"] = $kv.Value
                }
            }
        }

        $global:PSDefaultParameterValues["Invoke-GitHubRestAPI:UrlParameter"] = $toCache

    }
}
