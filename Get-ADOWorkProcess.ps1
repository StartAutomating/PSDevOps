function Get-ADOWorkProcess
{
    <#
    .Synopsis
        Gets work processes from ADO.
    .Description
        Gets work processes from Azure DevOps.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/list?view=azure-devops-rest-5.1
    .Example
        Get-ADOWorkProcess -Organization StartAutomating -PersonalAccessToken $pat
    #>
    param(
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
    $ApiVersion = "5.1-preview")

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }
    process {
        $uri = $Server, $Organization, '_apis/work/processes?' -join '/'
        if ($ApiVersion) {
            $uri += "api-version=$ApiVersion"
        }

        Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.WorkProcess", "PSDevOps.WorkProcess" -Property @{
            Organization = $Organization
            Server = $Server
        }
    }
}
