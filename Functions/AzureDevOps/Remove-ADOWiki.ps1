function Remove-ADOWiki {
    <#
    .Synopsis
        Removes Azure DevOps Wikis
    .Description
        Removes Azure DevOps Wikis from a project.
    .Example
        Remove-ADOWiki -Organization MyOrg -Project MyProject
    .Link
        Add-ADOWiki
    .Link
        Get-ADOWiki
    .Link
         https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/delete
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High',DefaultParameterSetName='wiki/wikis/{WikiID}')]
    [OutputType([Nullable],[Hashtable])]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The WikiID.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $WikiID,

    # The RepositoryID.  If this is the same as the WikiID, it is a ProjectWiki, and the repository will be removed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryID,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q = [Collections.Queue]::new()
    }

    process {
        $ParameterSet = $psCmdlet.ParameterSetName
        $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).

            $c++
            Write-Progress "Removing $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$Organization $Project $Team" -Id $id -PercentComplete ($c * 100/$t)

            if ($WikiID -eq $RepositoryID) {
                $parameterSet = 'git/repositories/{RepositoryId}'
            }

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    $Project
                    if ($Team) { $team }
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne ''  -join '/'

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

            $invokeParams.Uri = $uri
            $invokeParams.Method  = 'DELETE'

            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("DELETE $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Removing $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$Organization $Project $Team" -Id $id -Completed
    }
}
