function Set-ADOWorkProcess
{
    <#
    .Synopsis
        Sets work processes in ADO.
    .Description
        Sets work processes in Azure DevOps.

        Can:
        * -Enable/-Disable processes
        * Set a -Default process
        * Provide a -NewName
        * Update the -Description
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/edit%20process
    .Example
        Get-ADOWorkProcess -Organization StartAutomating -PersonalAccessToken $pat |
            Where-Object Name -Ne TheNameOfTheCurrentProcess |
            Set-ADOWorkProcess -Disable
    .Example
        Get-ADOProject -Organization StartAutomating -PersonalAccessToken $pat |
            Get-ADOWorkProcess |
            Set-ADOWorkPrcoess -Description "Updating Description"
    #>
    [CmdletBinding(DefaultParameterSetName='/{Organization}/_apis/work/processes', SupportsShouldProcess)]
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
    [Alias('TypeID')]
    [string]
    $ProcessID,

    # If set, will make the work process the default for new projects.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Default,

    # If provided, will rename the work process.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $NewName,

    # If provided, will update the description on the work process.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # If set, will disable the work process.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Disabled')]
    [switch]
    $Disable,

    # If set, will enable the work process.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Enabled')]
    [switch]
    $Enable,

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

    dynamicParam { Invoke-ADORestAPI -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = Invoke-ADORestAPI -MapParameter $PSBoundParameters
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

        $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $psParameterSet)

        $queryParams = @{}
        if ($ApiVersion) {
            $queryParams['api-version'] = $ApiVersion
        }

        $typeName = @($psParameterSet -split '/')[-1].TrimEnd('s') -replace
            'processe$', 'WorkProcess' -replace
            '\{ProcessId\}', 'WorkProcess'

        $addProperty = @{Organization=$Organization; Server = $Server}
        if ($ProcessID) {
            $addProperty['ProcessID'] = $ProcessID
        }

        $invokeParams.PSTypename = "$Organization.$typeName", "PSDevOps.$typeName"
        $invokeParams.Property = $addProperty
        $invokeParams.Uri = $uri
        $invokeParams.QueryParameter = $queryParams
        $invokeParams.Method = 'PATCH'
        $body = @{}
        if ($NewName) { $body.Name = $NewName }
        if ($Description) { $body.Description = $Description  }
        if ($Disable) { $body.IsEnabled = $false }
        if ($Enable -and -not $Disable) { $body.IsEnabled = $true }
        if ($Default.IsPresent)  { $body.IsDefault = [bool]$Default }
        $invokeParams.Body = $body
        if ($WhatIfPreference) {
            $invokeParams.Remove('PersonalAccessToken')
            return $invokeParams
        }
        if ($psCmdlet.ShouldProcess("Update Work $($ProcessID)")) {
            Invoke-ADORestAPI @invokeParams
        }
    }
}

