function Import-ADOProxy
{
    <#
    .Synopsis
        Imports an Azure DevOps Proxy
    .Description
        Imports a Proxy Module for Azure DevOps or TFS.

        A Proxy module will wrap all commands, but will always provide one or more default parameters.
    .Example
        Import-ADOProxy -Organization StartAutomating
    .Example
        Import-ADOProxy -Organization StartAutomating -Prefix SA
    .Example
        Import-ADOProxy -Organization StartAutomating -Project PSDevOps -IncludeCommand *Build* -Prefix SADO
    #>
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Organization,

    # The project.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The server.  This can be used to provide a TFS instance
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server,

    # The prefix for all commands in the proxy module.
    # If not provided, this will be the -Server + -Organization + -Project.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Prefix,

    # A list of command wildcards to include.  By default, all applicable commands.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $IncludeCommand = '*',

    # A list of commands to exclude.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ExcludeCommand,

    # If set, will return the imported module.
    [switch]
    $PassThru,

    # If set, will unload a previously loaded copy of the module.
    [switch]
    $Force
    )

    begin {
        $myModuleCommands =
            @(if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                  $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands.Values
            })
    }
    process {
        if (-not $Prefix) {
            if ($Server) {
                $Prefix = $Server.DnsSafeHost -replace '\W',''
            }

            $Prefix+= $Organization -replace '\W',''
            if ($Project) {
                $Prefix += $Project -replace '\W', ''
            }
        }

        $alreadyLoaded = Get-Module -Name $Prefix
        if ($alreadyLoaded -and -not $force) {
            if ($PassThru) { $alreadyLoaded }
            return
        } elseif ($alreadyLoaded -and $force) {
            $alreadyLoaded | Remove-Module
        }

        $filteredCommands =
            @(:nextCommand foreach ($cmd in $myModuleCommands) {
                if ($cmd.Noun -eq $MyInvocation.MyCommand.Noun) { continue }
                if (-not $cmd.Parameters.Organization) { continue }
                $shouldInclude = $false
                foreach ($Inclusion in $IncludeCommand) {
                    $shouldInclude = $cmd -like $Inclusion
                    if ($shouldInclude) { break }
                }
                if (-not $shouldInclude)  { continue }
                foreach ($ex in $ExcludeCommand) {
                    if ($cmd -like $ex) { continue nextCommand }
                }
                $cmd
            })

        $proxyCommands =
            @(foreach ($cmd in $filteredCommands) {
                $cmdMd = [Management.Automation.CommandMetaData]$cmd
                foreach ($ok in $override.Keys) {
                    $null = $cmdMd.Parameters.Remove($ok)
                }
                $proxy = [Management.Automation.ProxyCommand]::Create($cmdMd)


                $insertDefaultsAt = $proxy.IndexOf('$scriptCmd')
                $proxy = $proxy.Insert($insertDefaultsAt, @"
        `$defaults = @'
$overrideJson
'@ | ConvertFrom-JSON
        foreach (`$prop in `$defaults.psobject.properties) {
            if (`$wrappedCmd.Parameters.(`$prop.Name)) {
                `$null = `$psBoundParameters.Remove(`$prop.Name)
                `$psBoundParameters[`$prop.Name] = `$prop.Value
            }
        }
"@ + [Environment]::NewLine + ' ' * 8)

                $insertDynamicParamsAt = $proxy.IndexOf('begin' + [Environment]::NewLine)
                $proxy = $proxy.Insert($insertDynamicParamsAt, @"
dynamicParam {
    . {$($GetInvokeParameters.ScriptBlock)} -DynamicParameter
}
"@)

                @(
                    "function $($cmdMd.Name -replace 'ADO', $prefix) {"
                    $proxy
                    '}'
                ) -join [Environment]::NewLine
            })

        New-Module -Name $Prefix -ScriptBlock ([ScriptBlock]::Create($proxyCommands -join [Environment]::NewLine)) |
            Import-Module -Global -PassThru:$passThru
    }
}
