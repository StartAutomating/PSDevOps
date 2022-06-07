function Set-ADOEndpoint
{
    <#
    .Synopsis
        Sets an ADO Endpoint
    .Description
        Sets a Azure DevOps Endpoint
    .Example
        Set-ADOEndpoint -ID 000-0000-0000 -Key AccessToken -AccessToken testValue
        Set-ADOEndpoint -ID 000-0000-0000 -Key userVariable -Value testValue
        Set-ADOEndpoint -ID 000-0000-0000 -Url 'https://example.com/service'
    .Link
        https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands
    #>
    [CmdletBinding(DefaultParameterSetName='Url')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Directly outputs in certain scenarios")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Confirmation would be impossible within host")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForUnusableFunction", "", Justification="Directly outputs in certain scenarios")]
    [OutputType([string])]
    param(
    # The identifier.
    [Parameter(Mandatory,ParameterSetName='Url',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='AccessToken',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='DataParameter',ValueFromPipelineByPropertyName)]
    [string]
    $ID,

    # The endpoint URL.
    [Parameter(Mandatory,ParameterSetName='Url',ValueFromPipelineByPropertyName)]
    [Alias('URI','EndpointURL')]
    [uri]
    $Url,

    # The access token
    [Parameter(Mandatory,ParameterSetName='AccessToken',ValueFromPipelineByPropertyName)]
    [Alias('AT')]
    [string]
    $AccessToken,

    # The name of the setting.
    [Parameter(Mandatory,ParameterSetName='DataParameter',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='AccessToken',ValueFromPipelineByPropertyName)]
    [Alias('Key','K','N')]
    [string]
    $Name,

    # The value of the setting.
    [Parameter(Mandatory,ParameterSetName='DataParameter',ValueFromPipelineByPropertyName)]
    [Alias('DataParameter','DP','V')]
    [string]
    $Value
    )

    process {
        #region Prepare Output
        if ($PSCmdlet.ParameterSetName -eq 'Url') {
            $out = "##vso[task.setendpoint id=$ID;field=url]$Url"
        }

        if ($PSCmdlet.ParameterSetName -eq 'AccessToken') {
            if (-not $name) { $name = 'AccessToken' }
            $out = "##vso[task.setendpoint id=$ID;field=authParameter;key=$Name]$AccessToken"
        }

        if ($PSCmdlet.ParameterSetName -eq 'DataParameter') {
            $out = "##vso[task.setendpoint id=$ID;field=dataParameter;key=$Name]$Value"
        }
        #endregion Prepare Output

        if ($env:Agent_ID -and $DebugPreference -eq 'SilentlyContinue') {
            Write-Host $out
        } else {
            $out
        }
    }
}