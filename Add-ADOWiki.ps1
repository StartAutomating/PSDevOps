function Add-ADOWiki {
    <#
    .Synopsis
        Creates Azure DevOps Wikis
    .Description
        Creates Azure DevOps Wikis
    .Example
        Add-ADOWiki -Organization MyOrg -Project MyProject -Name MyWiki
    .Example
        Get-ADORepository -Organization MyOrg -Project MyProject |
            Add-ADOWiki -Name BuildHistory
    .Link
        Get-ADOWiki
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wiki/wikis/create
    #>
    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName='wiki/wikis')]
    [OutputType('PSDevOps.Wiki')]
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

    # The name of the wiki.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The ID of the repository used for the wiki.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryID,

    # The type of the wiki.  This can be either 'ProjectWiki' or 'CodeWiki'.
    # If a -RepositoryID is provided, this will be ignored as it must be a CodeWiki.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('ProjectWiki','CodeWiki')]
    [string]
    $WikiType = 'ProjectWiki',

    # The root path of the wiki within the repository.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('MappedPath')]
    [string]
    $RootPath,

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
        $originalInvokeParams = @{} + $invokeParams
        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).
            $projectID =
                if ($Project -as [guid]) {
                    $Project
                } else {
                    Get-ADOProject -Organization $Organization -Project $Project @originalInvokeParams |
                        Select-Object -ExpandProperty ProjectID
                }
            $c++
            Write-Progress "Adding $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$Organization $Project $Team" -Id $id -PercentComplete ($c * 100/$t)

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    $Project
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
            $invokeParams.Method  = 'POST'
            $additionalProperty = @{Organization=$Organization;Project=$Project}
            $invokeParams.Property = $additionalProperty
            $body = @{
                name = $Name
                projectID = $projectID
            }



            if ($RepositoryID) {
                $body.repositoryID = $RepositoryID
                $body.type = 'CodeWiki'
            }
            else {
                $body.type = $WikiType
            }

            if ($RootPath) {
                $body.MappedPath = $RootPath
            }

            $invokeParams.Body = $body

            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("POST $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Adding $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$Organization $Project $Team" -Id $id -Completed
    }
}


