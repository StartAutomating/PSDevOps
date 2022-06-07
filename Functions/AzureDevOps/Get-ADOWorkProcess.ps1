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
    .Example
        Get-ADOProject -Organization StartAutomating -PersonalAccessToken $pat | Get-ADOWorkProcess
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/work/processes')]
    [OutputType('PSDevOps.WorkProcess')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project Identifier.  If this is provided, will get the work process associated with that project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='/{Organization}/_apis/projects/{ProjectID}/properties')]
    [string]
    $ProjectID,

    # The process identifier
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workItemTypes',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/behaviors',ValueFromPipelineByPropertyName)]
    [Alias('TypeID')]
    [string]
    $ProcessID,

    # If set, will list work item types in a given Work process.
    [Parameter(Mandatory,ParameterSetName='/{Organization}/_apis/work/processes/{ProcessId}/workItemTypes',ValueFromPipelineByPropertyName)]
    [Alias('WorkItemTypes')]
    [switch]
    $WorkItemType,

    # If set, will list behaviors associated with a given work process.
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
        $psParameterSet = $psCmdlet.ParameterSetName
        if ($psParameterSet -eq '/{Organization}/_apis/projects/{ProjectID}/properties')
        {
            $processId =
                Get-ADOProject -Organization $Organization -ProjectID $ProjectID -Metadata @invokeParams -Server $Server |
                    Where-Object Name -EQ System.ProcessTemplateType |
                    Select-Object -ExpandProperty Value
            $psParameterSet = $MyInvocation.MyCommand.Parameters['ProcessID'].ParameterSets.Keys |
                Sort-Object Length |
                Select-Object -First 1
        }

        $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $psParameterSet) + '?'
        if ($ApiVersion) {
            $uri += "api-version=$ApiVersion"
        }

        $typeName = @($psParameterSet -split '/')[-1].TrimEnd('s') -replace
            'processe$', 'WorkProcess' -replace
            '\{ProcessId\}', 'WorkProcess'

        $addProperty = @{Organization=$Organization; Server = $Server}
        if ($ProcessID) {
            $addProperty['ProcessID'] = $ProcessID
        }

        Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.$typeName", "PSDevOps.$typeName" -Property $addProperty
    }
}
