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
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/work/processes')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workItemTypes',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors',ValueFromPipelineByPropertyName)]
    [Alias('TypeID')]
    [string]
    $ProcessID,

    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workItemTypes',ValueFromPipelineByPropertyName)]
    [Alias('WorkItemTypes')]
    [switch]
    $WorkItemType,

    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors',ValueFromPipelineByPropertyName)]
    [Alias('Behaviors')]
    [switch]
    $Behavior,

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
        $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $PSCmdlet.ParameterSetName) + '?'
        if ($ApiVersion) {
            $uri += "api-version=$ApiVersion"
        }

        $typeName = @($psCmdlet.ParameterSetName -split '/')[-1].TrimEnd('s') -replace 'processe$', 'WorkProcess'

        Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.$typeName", "PSDevOps.$typeName" -Property @{
            Organization = $Organization
            Server = $Server
        }
    }
}
