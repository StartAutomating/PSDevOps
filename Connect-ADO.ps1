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
            if ($cmd.Name -notlike '*-ADO*') { continue }
            foreach ($kv in $toCache.GetEnumerator()) {
                $global:PSDefaultParameterValues["${cmd}:$($kv.Key)"] = $kv.Value
            }
        }
        #endregion Set PSDefaultParameterValues

        #region Cache PersonalAccessToken
        if ($PersonalAccessToken) {
            $Script:CachedPersonalAccessToken = $PersonalAccessToken
            $getProjects = Get-ADOProject @PSBoundParameters
            if (-not $getProjects) {
                Disconnect-ADO
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
    }
}
