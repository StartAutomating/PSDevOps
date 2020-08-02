function Remove-ADOProject
{
    <#
    .Synopsis
        Removes projects from Azure DevOps.
    .Description
        Removes projects in Azure DevOps or TFS.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/states/delete?view=azure-devops-rest-5.1
    .Example
        Remove-ADOProject -Organization StartAutomating -Project TestProject1 -PersonalAccessToken $pat
    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    [OutputType([Nullable],[PSObject])]
    param(
    # The name or ID of the project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('ProjectName', 'ProjectID','ID')]
    [string]
    $NameOrID,

    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

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
        $uri = @(
            "$Server".TrimEnd('/')
            $Organization
            '_apis'
            'projects'
            if ($NameOrID -as [guid]) {
                $NameOrID
            } else {
                $myParams = @{} + $PSBoundParameters
                $myParams.Remove('WhatIf')
                $myParams.Remove('Confirm')
                Get-ADOProject @myParams | Select-Object -First 1 -ExpandProperty ID
            }
        ) -join '/'
        $uri += '?'
        if ($Server -ne 'https://dev.azure.com/' -and
            -not $PSBoundParameters.ApiVersion) {
            $ApiVersion = '2.0'
        }
        if ($ApiVersion) {
            $uri += "api-version=$ApiVersion"
        }

        $invokeParams.Uri = $uri
        $invokeParams.Method = 'DELETE'
        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams

        }
        if (-not $PSCmdlet.ShouldProcess("DELETE $uri")) { return }
        Invoke-ADORestAPI @invokeParams
    }
}