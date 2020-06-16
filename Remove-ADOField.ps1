function Remove-ADOField
{
    <#
    .Synopsis
        Removes fields in Azure DevOps
    .Description
        Removes fields in Azure DevOps or Team Foundation Server.
    .Example
        Remove-ADOField -Name Cmdlet.Verb
    .Example
        Remove-ADOField -Name IsDCR
    .Link
        Get-ADOField
    .Link
        New-ADOField
    .Link
        Invoke-ADORestAPI
    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for nulls")]
    param(
    # The name or reference name of the field
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Alias('FriendlyName', 'DisplayName', 'ReferenceName','SystemName')]
    [string]
    $Name,

    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

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
    }

    process {
        $uriBase = "$Server".TrimEnd('/'), $Organization, $(if ($Project) {$Project }) -ne $null -join '/'

        $uri = $uriBase, '_apis/wit/fields', "${name}?" -join '/'

        if ($Server -ne 'https://dev.azure.com/' -and
            -not $PSBoundParameters.ApiVersion) {
            $ApiVersion = '2.0'
        }
        $uri +=
            if ($ApiVersion) {
                "api-version=$ApiVersion"
            }

        $invokeParams.Uri = $uri
        $invokeParams.Method = 'DELETE'
        if (-not $PSCmdlet.ShouldProcess("DELETE $uri")) { return }

        Invoke-ADORestAPI @invokeParams
    }
}