function Connect-ADO
{
    <#
    .Synopsis
        Connects to Azure DeVOps
    .Description
        Connects the current PowerShell session to Azure DeVOps or a Team Foundation Server.

        Information passed to Connect-ADO will be used as the default parameters to all -ADO* commands from PSDevOps.

        PersonalAccessTokens will be cached separately to improve security.
    .Example
        Connect-ADO -Organization StartAutomating -PersonalAccessToken $myPat
    .Link
        Disconnect-ADO
    #>
    [OutputType('PSDevOps.Connection')]
    param(
    # The organization.
    # When connecting to TFS, this is the Project Collection.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Personal Access Token.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('PAT')]
    [string]
    $PersonalAccessToken,

    # If set, will use default credentials when connecting.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $UseDefaultCredentials,

    # The credential used to connect.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Management.Automation.PSCredential]
    $Credential,

    # The Server.  If this points to a TFS server, it should be the root TFS url, i.e. http://localhost:8080/tfs
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server
    )

    begin {
        $myModuleCommands =
            @(if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                  $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands.Values
            })
    }

    process {
        if (-not $PSDefaultParameterValues) {
            Write-Error "PSDefaultParameterValues not found"
            return
        }

        $toCache = [Ordered]@{} + $PSBoundParameters
        $toCache.Remove('PersonalAccessToken')
        #region Set PSDefaultParameterValues

        foreach ($cmd in $myModuleCommands) {
            if ($cmd.Name -notlike '*-ADO*') { continue } # If its not an Azure DevOps command, skip it.
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
        #endregion Set PSDefaultParameterValues

        #region Cache PersonalAccessToken
        if ($PersonalAccessToken) {
            $Script:CachedPersonalAccessToken = $PersonalAccessToken
            $getProjects = @(Get-ADOProject @PSBoundParameters)
            $getMyTeams  = @(Get-ADOTeam @PSBoundParameters -Mine)
            if (-not ($getMyTeams -or $getProjects)) {
                Disconnect-ADO
                return
            }


        }
        #endregion Cache PersonalAccessToken

        #region Cache and Output Connection
        $script:ADOConnectionInfo = $toCache
        $output = [PSCustomObject]$toCache
        $output.pstypenames.clear()
        $output.pstypenames.add("$Organization.Connection")
        $output.pstypenames.add('PSDevOps.Connection')
        $output
        #endregion Cache and Output Connection

        $registerArgumentCompleter =
                $ExecutionContext.SessionState.InvokeCommand.GetCommand('Register-ArgumentCompleter','Cmdlet')

        if ($registerArgumentCompleter) {
            $unique = @{
                Project   = $getMyTeams | Select-Object -ExpandProperty ProjectName -Unique
                Team      = $getMyTeams | Select-Object -ExpandProperty Team        -Unique
                TeamID    = $getMyTeams | Select-Object -ExpandProperty TeamID      -Unique
                ProjectID = $getMyTeams | Select-Object -ExpandProperty ProjectID   -Unique
            }

            $uniqueCompleter = @{}
            foreach ($u in $unique.GetEnumerator()) {
                $quotedValues = @(foreach ($v in $u.Value) {
                    if ($v.Contains(' ')) {
                        "'''$v'''"
                    }
                    else {
                        "'$v'"
                    }
                }) | Sort-Object
                $uniqueCompleter[$u.Key] = [ScriptBlock]::Create(
                    'param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)' +
                    "$($quotedValues -join ",") | Where-Object { `$_ -like `"`$wordToComplete*`"}"
                )
            }

            $uniqueCommands = @{}
            foreach ($u in $unique.GetEnumerator()) {
                $uniqueCommands[$u.Key] = @()
            }

            foreach ($cmd in $myModuleCommands) {
                if ($cmd.Name -notlike '*-ADO*') { continue }
                foreach ($u in $unique.Keys) {
                    if (-not $cmd.Parameters.($u)) { continue }
                    $uniqueCommands[$u]+=$cmd.Name
                }
            }

            foreach ($u in $uniqueCommands.Keys) {
                & $registerArgumentCompleter -CommandName $uniqueCommands[$u] -ParameterName $u -ScriptBlock $uniqueCompleter[$u]
            }
        }
    }
}
