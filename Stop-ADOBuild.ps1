function Stop-ADOBuild
{
    <#
    .Synopsis
        Stops an Azure DevOps Build
    .Description
        Cancels a running Azure DevOps Build.
    .Link
        Start-ADOBuild
    .Link
        Get-ADOBuild
    .Example
        Get-ADOBuild -Organization StartAutomating -Project PSDevOps -BuildResult None |
            Stop-ADOBuild
    .Example
        Stop-ADOBuild -Organization StartAutomating -Project PSDevOps -BuildID 180
    #>
    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName='build/builds/{buildId}')]
    [OutputType('PSDevOps.Build',[Hashtable])]
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
    $BuildID)

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

        $invokeParams.PSTypeName = @( # Prepare a list of typenames so we can customize formatting:
            "$Organization.$Project.Build" # * $Organization.$Project.Build
            "$Organization.Build" # * $Organization.Build
            "PSDevOps.Build" # * PSDevOps.Build
        )

        $invokeParams.Method = 'PATCH'
        $invokeParams.Body = @{
            status = 'cancelling'
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
