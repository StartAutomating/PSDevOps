function Remove-ADOArtifactFeed
{
    <#
    .Synopsis
        Removes artifact feeds from Azure DevOps
    .Description
        Removes artifact feeds from Azure DevOps.  Artifact feeds are used to publish packages.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        "PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for nulls"
    )]
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact='High',
        DefaultParameterSetName='packaging/feeds/{feedId}'
    )]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Feed Name or ID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ValidatePattern(
        #?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd
        '\A[^\s\|\?\/\\\:\&\$\*\"\[\]\>]+\z'
    )]
    [Alias('FullyQualifiedID')]
    [string]
    $FeedID,

    # The View Name or ID
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidatePattern(
        #?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd
        '\A[^\s\|\?\/\\\:\&\$\*\"\[\]\>]{0,}\z'
    )]
    [string]
    $ViewID,

    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/views/{viewId}')]
    [switch]
    $View,

    # The server.  By default https://feeds.dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://feeds.dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    [string]
    $ApiVersion = "5.1-preview")

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $parameterSetName = $psCmdlet.ParameterSetName
        if (-not $ViewID) {
            $parameterSetName = $MyInvocation.MyCommand.DefaultParameterSet
        }
        $invokeParams.Uri = # First construct the URI.  It's made up of:
            "$(@(
                "$server".TrimEnd('/') # * The Server
                $Organization # * The Organization
                $(if ($Project) { $Project }) # * The Project
                '_apis' #* '_apis'
                . $ReplaceRouteParameter $parameterSetName #* and the replaced route parameters.
            )  -join '/')?$( # Followed by a query string, containing
            @(
                if ($Server -ne 'https://feeds.dev.azure.com/' -and 
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"
        $invokeParams.Method = 'DELETE'
        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }

        if ($PSCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.Uri)")) {
            $null = Invoke-ADORestAPI @invokeParams
        }
    }
}
