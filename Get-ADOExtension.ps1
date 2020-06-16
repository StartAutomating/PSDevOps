function Get-ADOExtension
{
    <#
    .Synopsis
        Gets Azure DevOps Extensions
    .Descriptions
        Gets Extensions to Azure DevOps.
    .Example
        Get-ADOExtension -Organization StartAutomating
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed%20extensions/list?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/extensionmanagement/installedextensions')]
    param(
    # The organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Organization,

    # A list of asset types
    [Alias('AssetTypes')]
    [string[]]
    $AssetType,

    # If set, will include disabled extensions
    [Alias('Disabled')]
    [switch]
    $IncludeDisabled,

    # If set, will include extension installation issues
    [Alias('IncludeInstallationIssue','IncludeInstallationIssues')]
    [switch]
    $InstallationIssue,

    # If set, will include errors
    [Alias('IncludeErrors')]
    [switch]
    $IncludeError,

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
            if ($Server -ne 'https://extmgmt.dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($ApiVersion) { # the api-version
                "api-version=$apiVersion"
            }
        ) -join '&'
        $typename = @($psCmdlet.ParameterSetName -split '/')[-1].TrimEnd('s') # We just need to drop the 's'
        $typeNames = @(
            "$organization.$typename"
            "PSDevOps.$typename"
        )

        Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property @{
            Organization = $Organization
            Server = $Server
        }
    }
}
