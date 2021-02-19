function Get-ADOExtension
{
    <#
    .Synopsis
        Gets Azure DevOps Extensions
    .Description
        Gets Extensions to Azure DevOps.
    .Example
        Get-ADOExtension -Organization StartAutomating
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/list?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/get?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/extensionmanagement/installedextensions')]
    [OutputType('PSDevOps.InstalledExtension')]
    param(
    # The organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Organization,

    # A wildcard of the extension name.  Only extensions where the Extension Name or ID matches the wildcard will be returned.
    [string]
    $ExtensionNameLike,

    # A regular expression of the extension name.  Only extensions where the Extension Name or ID matches the wildcard will be returned.
    [string]
    $ExtensionNameMatch,

    # A wildcard of the publisher name.  Only extensions where the Publisher Name or ID matches the wildcard will be returned.
    [string]
    $PublisherNameLike,

    # A regular expression of the publisher name.  Only extensions where the Publisher Name or ID matches the wildcard will be returned.
    [string]
    $PublisherNameMatch,

    # The Publisher of the Extension.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/{Scope}/Collections/{DataCollection}/Documents/{DataId}'
    )]
    [string]
    $PublisherID,

    # The Extension Identifier.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/{Scope}/Collections/{DataCollection}/Documents/{DataId}'
    )]
    [string]
    $ExtensionID,

    # The data collection
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/{Scope}/Collections/{DataCollection}/Documents/{DataId}'
    )]
    [Alias('TableName','Table_Name', 'DocumentCollection')]
    [string]
    $DataCollection,

    # The data identifier
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='/_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/{Scope}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [Alias('RowKey','DocumentID')]
    [string]
    $DataID,

    # The data scope.  
    # Can either be Project or User/Me.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/{Scope}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [Alias('RowKey','DocumentID')]
    [string]
    $Scope,

    # A list of asset types
    [Parameter(ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Alias('AssetTypes')]
    [string[]]
    $AssetType,

    # If set, will include disabled extensions
    [Parameter(ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Alias('Disabled')]
    [switch]
    $IncludeDisabled,

    # If set, will include extension installation issues
    [Parameter(ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Alias('IncludeInstallationIssue','IncludeInstallationIssues')]
    [switch]
    $InstallationIssue,

    # If set, will include errors
    [Parameter(ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Alias('IncludeErrors')]
    [switch]
    $IncludeError,

    # If set, will expand contributions.
    [Parameter(ParameterSetName='/{Organization}/_apis/extensionmanagement/installedExtensionsByName/{PublisherID}/{ExtensionID}')]
    [Alias('Contributions')]
    [switch]
    $Contribution,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://extmgmt.dev.azure.com/",

    # The api version.  By default, 5.1.
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
    }

    process {
        $uri = # The URI is comprised of:
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'

        $uri += '?' # The URI has a query string containing:
        if ($psCmdlet.ParameterSetName -like '*/Data/*') {
            $Server = "https://$organization.extmgmt.dev.azure.com/"
        }
        $uri += @(
            if ($IncludeDisabled) {
                "includeDisabledExtensions=true"
            }
            if ($InstallationIssue) {
                "includeInstallationIssues=true"
            }
            if ($IncludeError) {
                "includeErrors=true"
            }
            if ($AssetType) {
                "assetTypes=$($AssetType -join ',')"
            }
            if ($Server -ne 'https://extmgmt.dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($ApiVersion) { # the api-version
                "api-version=$apiVersion"
            }
        ) -join '&'

        if ($PSCmdlet.ParameterSetName -like '*/Data/*') {
            Invoke-ADORestAPI -Uri $uri @invokeParams
            return
        }


        $typename = @($psCmdlet.ParameterSetName -split '/')[-1].TrimEnd('s') # We just need to drop the 's'
        $typeNames = @(
            "$organization.$typename"
            "PSDevOps.$typename"
        )

        Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property @{
            Organization = $Organization
            Server = $Server
        } -DecorateProperty @{'Contributions'="$Organization.ExtensionContribution", 'PSDevOps.ExtensionContribution'}|
            & { process {
                $out = $_
                if ($PublisherNameLike -and (
                    $out.PublisherName -notlike $PublisherNameLike -and
                    $out.PublisherID -notlike $PublisherNameLike
                )) { return }
                if ($PublisherNameMatch -and (
                    $out.PublisherName -notmatch $PublisherNameMatch -and
                    $out.PublisherID -notmatch $PublisherNameMatch
                )) { return }
                if ($ExtensionNameLike -and (
                    $out.ExtensionName -notlike $ExtensionNameLike -and
                    $out.ExtensionID -notlike $ExtensionNameLike
                )) { return }
                if ($ExtensionNameMatch -and (
                    $out.ExtensionName -notmatch $ExtensionNameMatch -and
                    $out.ExtensionID -notmatch $ExtensionNameMatch
                )) { return }

                if ($Contribution) {
                    $out.Contributions |
                        & { process {
                            $contrib = $_
                            $contrib.psobject.Members.Add(
                                [PSNoteProperty]::new('Organization', $Organization), $true)
                            $contrib.psobject.Members.Add(
                                [PSNoteProperty]::new('Server', $Server), $true)
                            $contrib.psobject.Members.Add(
                                [PSNoteProperty]::new('PublisherName', $out.PublisherName), $true)
                            $contrib.psobject.Members.Add(
                                [PSNoteProperty]::new('PublisherID', $out.PublisherID), $true)
                            $contrib.psobject.Members.Add(
                                [PSNoteProperty]::new('ExtensionName', $out.ExtensionName), $true)
                            $contrib.psobject.Members.Add(
                                [PSNoteProperty]::new('ExtensionID', $out.ExtensionID), $true)
                            $contrib
                        } }
                } else {
                    $out
                }
            } }
    }
}
