function Update-ADOBuild
{
    <#
    .Synopsis
        Updates builds and build definitions
    .Description
        Updates builds and build definitions in Azure DevOps.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/update%20build?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/update?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='build/builds/{buildId}',SupportsShouldProcess)]
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

    # The server.  By default https://dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    [string]
    $ApiVersion = "5.1",

    # The Build ID
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}',ValueFromPipelineByPropertyName)]
    [string]
    $BuildID,

    # The updated build information.  This only needs to contain the changed information.
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}',ValueFromPipelineByPropertyName)]
    [PSObject]
    $Build,

    # The Build Definition ID
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}',ValueFromPipelineByPropertyName)]
    [string]
    $DefinitionID,

    # The new build definition.  This needs to contain the entire definition.
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}',ValueFromPipeline)]
    [PSObject]
    $Definition)

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }


    process {
        $invokeParams.Uri = # First construct the URI.  It's made up of:
            "$(@(
                "$server".TrimEnd('/') # * The Server
                $Organization # * The Organization
                $Project # * The Project
                '_apis' #* '_apis'
                . $ReplaceRouteParameter $PSCmdlet.ParameterSetName #* and the replaced route parameters.
            )  -join '/')?$( # Followed by a query string, containing
            @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"

        $subtypename = @($pscmdlet.ParameterSetName -replace '/{\w+}', '' -split '/')[-1].TrimEnd('s')
        $subtypeName =
            if ($subtypename -eq 'Build') {
                ''
            } else {
                '.' + $subtypename.Substring(0,1).ToUpper() + $subtypename.Substring(1)
            }
        $invokeParams.PSTypeName = @( # Prepare a list of typenames so we can customize formatting:
            "$Organization.$Project.Build$subTypeName" # * $Organization.$Project.Build
            "$Organization.Build$subTypeName" # * $Organization.Build
            "StartAutomating.PSDevOps.Build$subTypeName" # * PSDevOps.Build
        )


        if ($psCmdlet.ParameterSetName -eq 'build/builds/{buildId}') {
            $invokeParams.Method = 'PATCH'
            $invokeParams.Body = $Build
        } else {
            $invokeParams.Method = 'PUT'
            $invokeParams.Body = $Definition
        }


        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }

        if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            Invoke-ADORestAPI @invokeParams -Property @{
                Organization = $Organization
                Project = $Project
                Server = $Server
            }
        }
    }
}

