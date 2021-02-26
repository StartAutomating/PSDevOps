function Set-ADOExtension
{
    <#
    .Synopsis
        Sets Azure DevOps Extension Data
    .Description
        Sets Data in Azure DevOps Extension Data Storage.
    .Example

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Organization,

        # The Publisher of the Extension.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [string]
    $PublisherID,

    # The Extension Identifier.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [string]
    $ExtensionID,

    # The data collection
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [Alias('TableName','Table_Name', 'DocumentCollection')]
    [string]
    $DataCollection,

    # The data identifier
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [Alias('RowKey','DocumentID')]
    [string]
    $DataID,

    # The scope type.  By default, the value "default" (which maps to Project Collection)
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [ValidateSet('Default','Project','User')]
    [string]
    $ScopeType = 'Default',

    # The scope modifier.  By default, the value "current" (which maps to the current project collection or project)
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [ValidateSet('Current','Me')]
    [string]
    $ScopeModifier = 'Current',


    # The input object
    [Parameter(Mandatory,ValueFromPipeline,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [PSObject]
    $InputObject,

    # If set, will overwrite existing contents of storage.
    # If not set, new properties may be added to an existing
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='_apis/extensionmanagement/installedExtensions/{PublisherID}/{ExtensionID}/Data/Scopes/{ScopeType}/{ScopeModifier}/Collections/{DataCollection}/Documents/{DataID}'
    )]
    [Alias('NoMerge','NoUpsert')]
    [switch]
    $Overwrite,

    # The server.  By default https://extmgmt.dev.azure.com/.
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
        if ($InputObject -is [Collections.IDictionary]) {
            $InputObject = [PSCustomObject]$InputObject
        } else {
            $InputObject = [PSObject]::new($InputObject)
        }
        foreach ($k in $MyInvocation.MyCommand.Parameters.Keys) {
            if ($InputObject.$k) {
                $InputObject.psobject.properties.Remove($k)
            }
        }
        if (-not $InputObject.id) { $InputObject | Add-Member NoteProperty ID $DataID -Force }
        $uri = # The URI is comprised of:
            @(
                "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                $Organization
                (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'

        $uri += '?' # The URI has a query string containing:
        

        $uri += @(
            if ($Server -ne "https://extmgmt.dev.azure.com/" -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            if ($ApiVersion) { # the api-version
                "api-version=$apiVersion"
            }
        ) -join '&'

        $existingData = Invoke-ADORestAPI -Uri $uri @invokeParams -ErrorAction SilentlyContinue 
        $existingDataWithID = $existingData | Where-Object id -EQ $DataID
        $InputObject | Add-Member NoteProperty id $DataID -Force 
        
        if ($existingDataWithID) {
            if (-not $Overwrite) {
                foreach ($prop in $existingDataWithID.psobject.properties) {
                    if (-not $inputObject.psobject.properties[$prop.Name]) {
                        $inputObject | Add-Member $prop.Name $prop.value
                    }
                }
            } else {
                $InputObject | Add-Member NoteProperty __etag $existingDataWithID.__etag -Force
            }
            
        }

        $invokeParams.Uri = $uri
        $invokeParams.Method = 'PUT'
        $invokeParams.Body = $InputObject
        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccesstoken')
            return $invokeParams
        }
        if ($psCmdlet.ShouldProcess("PUT $uri")) {
            Invoke-ADORestAPI @invokeParams
        }        
    }
}
