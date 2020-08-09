function Enable-ADOExtension
{
    <#
    .Synopsis
        Enables Azure DevOps Extensions.
    .Description
        Enables one or more Azure DevOps Extensions.
    .Example
        Enable-ADOExtension -Organization StartAutomating -PublisherID ms-samples -ExtensionID samples-contributions-guide
    .Link
        Get-ADOExtension
    .Link
        Disable-ADOExtension
    #>
    [CmdletBinding(SupportsShouldProcess,
        DefaultParameterSetName='/{organization}/_apis/extensionmanagement/installedextensions')]
    [OutputType('PSDevOps.Extension')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Publisher of an Extension.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $PublisherID,

    # The name of the Extension.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $ExtensionID,

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
        $q.Enqueue($PSBoundParameters)
    }

    end {
        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).
            $null = $DequedInput.Remove('WhatIf')
            $null = $DequedInput.Remove('Confirm')
            $theExt = Get-ADOExtension @dequedInput
            if (-not $theExt) { continue }
            $invokeParams.Uri = @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),                    
                    (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName)
                                             # and any parameterized URLs in this parameter set.
            ) -join '/'
            $invokeParams.Uri += '?' + @(
                if ($Server -ne 'https://extmgmt.dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'
            $invokeParams.PSTypeName = "$Organization.Extension", 'PSDevOps.Extension'
            $invokeParams.Method = 'PATCH'
            $invokeParams.body = @{
                publisherId = $theExt.publisherId
                extensionId = $theExt.extensionId
                installState=  @{
                    flags = 'none'
                }
            }
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }            
            if (-not $PsCmdlet.ShouldProcess("Enable $PublisherID $ExtensionID")) { continue }
            Invoke-ADORestAPI @invokeParams
        }
    }
}
