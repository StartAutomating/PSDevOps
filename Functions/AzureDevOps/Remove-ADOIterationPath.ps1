function Remove-ADOIterationPath
{
    <#
    .Synopsis
        Removes an Azure DevOps IterationPath.
    .Description
        Removes an Azure DevOps IterationPath.  IterationPaths are used to logically group work items within a project.
    .Example
        Remove-ADOIterationPath -Organization MyOrg -Project MyProject -IterationPath MyIterationPath
    .Link
        Add-ADOIterationPath
    .Link
        Get-ADOIterationPath
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    [OutputType([Nullable],[PSObject])]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The IterationPath
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Path')]
    [string]
    $IterationPath,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview")
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

        $q = [Collections.Queue]::new()
    }

    process {
        $q.Enqueue(@{} + $psboundParameters)
    }

    end {
        $c,$t, $id = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            $qi = $q.Dequeue()
            foreach ($kv in $qi.GetEnumerator()) {
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
            }
            if ($t -gt 1) {
                $c++
                Write-Progress "Removing Iteration Paths" "$IterationPath " -PercentComplete ($c * 100 / $t) -Id $id
            }

            if ($IterationPath -like "\$project\*") {
                $IterationPath = @($IterationPath -split '\\', 4)[-1]
            }
            $IterationPathUrl = "/{Organization}/{Project}/_apis/wit/classificationNodes/Iterations/$IterationPath"

             $uri =
                $Server.ToString().TrimEnd('/') +
                (. $ReplaceRouteParameter $IterationPathUrl) +
                '?' + $(
                    if ($Server -ne 'https://dev.azure.com' -and -not $psBoundParameters['apiVersion']) {
                        $apiVersion = "2.0"
                    }
                    if ($ApiVersion) {
                        "api-version=$ApiVersion"
                    }
                )

            $invokeParams.Uri = $uri
            $invokeParams.Method = 'DELETE'

            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $PSCmdlet.ShouldProcess("Remove IterationPath $IterationPath")) { continue }
            $typeName = "$Organization.IterationPath", "$Organization.$project.IterationPath", "PSDevOps.IterationPath"

            Invoke-ADORestAPI @invokeParams -PSTypeName $typeName
        }

        if ($t -gt 1) {
            Write-Progress "Removing Iteration Paths" " " -Completed -Id $id
        }
    }
}
