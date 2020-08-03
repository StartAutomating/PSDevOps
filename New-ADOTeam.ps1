function New-ADOTeam
{
    <#
    .Synopsis
        Gets Azure DevOps Teams
    .Description
        Gets teams from Azure DevOps or TFS
    .Example
        New-ADOTeam -Organization StartAutomating -Project PSDevOps -Team MyNewTeam -WhatIf
    .Link
        Get-ADOTeam
    .Link
        Get-ADOProject
    #>
    [OutputType('PSDevOps.Team')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The Organization.
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The project name or identifier
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Team Name
    [Parameter(Mandatory,ParameterSetName='projects/{Project}/teams',ValueFromPipelineByPropertyName)]
    [string]
    $Team,

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

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $psParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne '' -join '/'
            Write-Progress "Creating Teams" "$uri" -PercentComplete ($c * 100/ $t) -Id $id
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

            $typename = @($psParameterSet -split '/')[-1].TrimEnd('s') -replace 'Member', 'TeamMember' # We just need to drop the 's'
            $typeNames = @(
                "$organization.$typename"
                "$organization.$Project.$typename"
                "PSDevOps.$typename"
            )
            $invokeParams.Method = 'POST'
            $invokeParams.Uri  = $uri
            $invokeParams.body = @{name=$Team}
            $invokeParams.PSTypeNames = $typeNames
            $invokeParams.Property = @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (! $PSCmdlet.ShouldProcess("Create $Organization\$Project\$team")) { continue }
            Invoke-ADORestAPI @invokeParams
        }
        Write-Progress "Creating Teams" " " -Completed -Id $id
    }
}
