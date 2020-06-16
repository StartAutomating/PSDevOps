function Remove-ADOBuild
{
    <#
    .Synopsis
        Removes builds and build definitions
    .Description
        Removes builds and build definitions from Azure DevOps.
    .Example
        Get-ADOBuild -Organization StartAutomating -Project PSDevOps |
            Select-Object -Last 1 |
            Remove-ADOBuild
    .Link
        Get-ADOBuild
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/delete?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/definitions/delete?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='build/builds/{buildId}',SupportsShouldProcess,ConfirmImpact='High')]
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

    # The server.  By default https://feeds.dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    [string]
    $ApiVersion = "5.1-preview",

    # The Build ID
    [Parameter(Mandatory,ParameterSetName='build/builds/{buildId}',ValueFromPipelineByPropertyName)]
    [string]
    $BuildID,

    # The Build Definition ID
    [Parameter(Mandatory,ParameterSetName='build/definitions/{definitionId}',ValueFromPipelineByPropertyName)]
    [string]
    $DefinitionID)
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
            "PSDevOps.Build$subTypeName" # * PSDevOps.Build
        )

        $invokeParams.Method = 'DELETE'

        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }


        if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            Invoke-ADORestAPI @invokeParams -Property @{
                Organization = $Organization
                Project = $Project
            }
        }
    }
}
