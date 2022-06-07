function Remove-ADOAgentPool
{
    <#
    .Synopsis
        Removes Azure DevOps Pools
    .Description
        Removes pools from Azure DevOps or TFS
    .Example
        Get-ADOAgentPool |
            Remove-ADOAgentPool -WhatIf
    .Link
        Get-ADOAgentPool
    #>
    [OutputType([Nullable], [Collections.IDictionary])]
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Pool Identifier
    [Parameter(Mandatory,ParameterSetName='distributedtask/pools/{poolId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='distributedtask/pools/{poolId}/agents/{agentId}',ValueFromPipelineByPropertyName)]
    [string]
    $PoolID,

    # The Agent Identifier
    [Parameter(Mandatory,ParameterSetName='distributedtask/pools/{poolId}/agents/{agentId}',ValueFromPipelineByPropertyName)]
    [string]
    $AgentID,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1")

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q = [Collections.Queue]::new()
    }

    process {
        $q.Enqueue(@{psParameterSet = $PSCmdlet.ParameterSetName} + $psBoundParameters)
    }

    end {
        $c, $t, $id  = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $dq $q
            $typename = @($psParameterSet -split '/' -notlike '{*}')[-1]
            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $psParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne '' -join '/'
            Write-Progress "Removing $typename" "$uri" -PercentComplete ($c * 100/ $t) -Id $id
            $c++
            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'


            $invokeParams.Method = 'DELETE'
            $invokeParams.Uri  = $uri
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (! $PSCmdlet.ShouldProcess("Delete $Organization\$Project\$team")) { continue }
            Invoke-ADORestAPI @invokeParams -PSTypeName $typenames -Property @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
        }

        Write-Progress "Removing $typename" " " -Completed -Id $id
    }
}


