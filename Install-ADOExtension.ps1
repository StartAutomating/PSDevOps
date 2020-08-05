function Install-ADOExtension {
    <#
    .Synopsis
        Installs Azure DevOps Extensions
    .Description
        Installs Azure DevOps Extensions from the Marketplace
    .Example
        Install-ADOExtension -PublisherName YodLabs -ExtensionName yodlabs-githubstats -Organization MyOrg
    .Link
        Get-ADOExtension
    .Link
        Uninstall-ADOExtension
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High',
        DefaultParameterSetName='_apis/extensionmanagement/installedextensionsbyname/{publisherName}/{extensionName}/{version}')]
    [OutputType('PSDevOps.Extension')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Publisher of an Extension.
    [Parameter(Mandatory,
        ValueFromPipelineByPropertyName)]
    [string]
    $PublisherName,

    # The name of the Extension.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $ExtensionName,

    # The version of the extension.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Version,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://extmgmt.dev.azure.com/",

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
            Write-Progress "Installing Extensions" "$Organization $PublisherName $ExtensionName" -Id $id -PercentComplete ($c * 100/$t)

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne ''  -join '/'

            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($Server -ne 'https://extmgmt.dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'

            $invokeParams.Uri = $uri
            $invokeParams.Method  = 'POST'
            $invokeParams.Property = @{Organization=$Organization}

            $invokeParams.PSTypeName = "$Organization.Extension", 'PSDevOps.Extension'
            $invokeParams.Body = $body

            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("POST $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Installing Extensions" " " -Id $id -Completed
    }
}
