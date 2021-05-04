function New-ADOWorkProcess
{
    <#
    .Synopsis
        Creates work processes in ADO.
    .Description
        Creates work processes in Azure DevOps.

        Must provide a -Name

        Can Provide:
        * -Description
        * -ParentProcessID (can be piped in, will default to the ID for 'Agile')
        * -ReferenceName
        
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/processes/create
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

    
    # The name of the work process
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # A description of the work process.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Description,
    
    # The parent process identifier.  If not provided, will default to the process ID for 'Agile'.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('TypeID','ParentProcessTypeID')]
    [string]
    $ParentProcessID = 'adcc42ab-9882-485e-a3ed-7678f01f66bc',      
    

    # A reference name for the work process.  If one is not provided, Azure Devops will automatically generate one.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ReferenceName,

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

        $uri = "$Server".TrimEnd('/') + (. $ReplaceRouteParameter $psParameterSet)

        $queryParams = @{}
        if ($ApiVersion) {
            $queryParams['api-version'] = $ApiVersion
        }

        $typeName = @($psParameterSet -split '/')[-1].TrimEnd('s') -replace
            'processe$', 'WorkProcess' -replace
            '\{ProcessId\}', 'WorkProcess'

        $addProperty = @{Organization=$Organization; Server = $Server}        
        $invokeParams.PSTypename = "$Organization.$typeName", "PSDevOps.$typeName"
        $invokeParams.Property = $addProperty
        $invokeParams.Uri = $uri
        $invokeParams.QueryParameter = $queryParams
        $invokeParams.Method = 'POST'
        $body = @{Name = $Name;parentProcessTypeId=$ParentProcessID}        
        if ($Description) { $body.Description = $Description  }
        if ($ReferenceName) { $body.ReferenceName = $ReferenceName }       
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

