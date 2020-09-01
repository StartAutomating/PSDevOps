function Disconnect-ADO
{
    <#
    .Synopsis
        Disconnects from Azure DevOps
    .Description
        Disconnects from Azure DevOps, clearing parameter value defaults and cached access tokens.
    .Example
        Disconnect-ADO
    .Link
        Connect-ADO
    #>
    [OutputType([Nullable], [PSObject])]
    [CmdletBinding(ConfirmImpact='High',SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForPipelineParameter", "", Justification="No parameters but -WhatIf and -Confirm")]
    param()

    begin {
        #region Find Commands
        $myModuleCommands =
            @(if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                  $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands.Values
            })
        #endregion Find Commands
    }

    end {
        if ($WhatIfPreference) { return $script:ADOConnectionInfo }
        if ($script:ADOConnectionInfo -and
            $PSCmdlet.ShouldProcess("Disconnect from $($script:ADOConnectionInfo.Organization)")) {
            #region Clear PSDefaultParameterValues
            foreach ($cmd in $myModuleCommands) {
                if ($cmd.Name -notlike '*-ADO*') { continue }
                foreach ($k in @(@($global:PSDefaultParameterValues.Keys) -like "${cmd}:*")) {
                    $global:PSDefaultParameterValues.Remove($k)
                }
            }
            #endregion Clear PSDefaultParameterValues
            $Script:CachedPersonalAccessToken = '' # Clear the cached access token
            $script:ADOConnectionInfo         = $null    # and the connection info.
        }
    }
}
