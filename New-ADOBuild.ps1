function New-ADOBuild
{
    <#
    .Synopsis
        Creates Azure DevOps Build Definitions
    .Description
        Creates Build Definitions in Azure DevOps.
    .Example
        New-ADOBuild -Organization StartAutomating -Project PSDevops -Name PSDevOps_CI -Repository @{
            id = 'StartAutomating/PSDevOps'
            type = 'GitHub'
            name = 'StartAutomating/PSDevOps'
            url  = 'https://github.com/StartAutomating/PSDevOps.git'
            defaultBranch = 'master'
            properties = @{
                connectedServiceId  = '2b65e3be-c457-4d61-b457-d883fb231ff2'
            }
        } -YAMLFilename azure-pipelines.yml
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/create
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='Low',DefaultParameterSetName='build/definitions')]
    [OutputType('PSDevOps.Build.Definition')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The name of the build.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The folder path of the definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Path = '\',

    # The path to a YAML file containing the build definition
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $YAMLFileName,

    # A comment about the build defintion revision.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Comment,

    # A description of the build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # The drop location for the build
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DropLocation,

    # The build number format
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $BuildNumberFormat,

    # The repository used by the build definition.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [PSObject]
    $Repository,

    # The queue used by the build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $Queue,

    # A collection of demands for the build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Demand,

    # A collection of variables for the build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Variable,

    # A collection of secrets for the build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Secret,

    # A list of tags for the build definition.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Tags')]
    [string[]]
    $Tag,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1"
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
            Write-Progress "Creating Builds $(@($ParameterSet -split '/')[-1])" "$Organization $Project" -Id $id -PercentComplete ($c * 100/$t)

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
                path = $Path
            }
            if ($YAMLFileName) {
                $body.process = @{type=2;yamlFileName=$YAMLFileName}
            }

            if ($Repository) {
                $body.repository = $Repository
            }
            if ($DropLocation) {
                $body.dropLocation = $DropLocation
            }

            $body.queue =
                if ($Queue) {
                    $Queue
                } else {
                    @{name='default'}
                }

            if ($Demand) {
                $body.demands = @(
                    foreach ($d in $Demand.GetEnumerator()) {
                        @{name=$d.Key;value=$d.Value}
                    }
                )
            }

            if ($Variable -or $Secret) {
                $body.variables = [Ordered]@{}
                if ($Variable) {
                    foreach ($v in $Variable.GetEnumerator()) {
                        $body.variables[$v.key] = @{value=$v.Value}
                    }
                }
                if ($Secret) {
                    foreach ($s in $Secret.GetEnumerator()) {
                        $body.variables[$s.Key] = @{value=$s.Value;isSecret=$true}
                    }
                }
            }

            $invokeParams.Body = $body
            $invokeParams.PSTypeName = "$Organization.$Project.Build.Definition", "$organization.Build.Definition", "PSDevOps.Build.Definition"
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("POST $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Creating Builds $(@($ParameterSet -split '/')[-1])" "$Organization $Project" -Id $id -Completed
    }
}
