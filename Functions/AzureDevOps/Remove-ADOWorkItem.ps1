function Remove-ADOWorkItem
{
    <#
    .Synopsis
        Remove work items from Azure DevOps
    .Description
        Remove work item from Azure DevOps or Team Foundation Server.
    .Example
        Remove-ADOWorkItem -Organization StartAutomating -Project PSDevOps -ID 10
    .Example
        Remove-ADOWorkItem -Organization StartAutomating -Project PSDevOps -Query "Select [System.ID] from WorkItems Where [System.Title] = 'Test-WorkItem'" -PersonalAccessToken $pat -Confirm:$false -Destroy
    .Link
        Invoke-ADORestAPI
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work%20items/delete?view=azure-devops-rest-5.1
    #>
    [CmdletBinding(DefaultParameterSetName='ByID', SupportsShouldProcess=$true, ConfirmImpact='High')]
    [OutputType([Nullable],[Collections.IDictionary])]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Work Item ID
    [Parameter(Mandatory,ParameterSetName='ByID',ValueFromPipelineByPropertyName)]
    [string]
    $ID,

    # A query
    [Parameter(Mandatory,ParameterSetName='ByQuery',ValueFromPipelineByPropertyName)]
    [string]
    $Query,

    # If set, will return work item shared queries
    [Parameter(Mandatory,ParameterSetName='/{Organization}/{Project}/_apis/wit/queries/{QueryID}',ValueFromPipelineByPropertyName)]
    [string]
    $QueryID,


    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1",
    
    # If set, the work item is deleted permanently. Please note: the destroy action is PERMANENT and cannot be undone.
    [switch]
    $Destroy)

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $psParameterSet = $PSCmdlet.ParameterSetName
        $in = $_
        if ($in.QueryID) {
            $psParameterSet = '/{Organization}/{Project}/_apis/wit/queries/{QueryID}'
        }
        if ($psParameterSet -eq 'ByID') { # If we're removing by ID
            $uriBase = "$Server".TrimEnd('/'), $Organization, $Project -join '/'
            $uri = $uriBase, "_apis/wit/workitems", "${ID}?" -join '/'

            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            $uri +=
                if ($ApiVersion) {
                    "api-version=$ApiVersion"
                }
            $uri +=
                if ($Destroy) {
                    "&destroy=true"
                }

            $invokeParams.Uri = $uri
            $invokeParams.Method = 'DELETE'
            if (-not $PSCmdlet.ShouldProcess("Remove Work Item $ID")) { return }
            Invoke-ADORestAPI @invokeParams
        } elseif ($psParameterSet -eq 'ByQuery') {


            $uri = "$Server".TrimEnd('/'), $Organization, $Project, "_apis/wit/wiql?" -join '/'
            $uri += if ($ApiVersion) {
                "api-version=$ApiVersion"
            }

            $invokeParams.Method = "POST"
            $invokeParams.Body = ConvertTo-Json @{query=$Query}
            $invokeParams["Uri"] = $uri

            $queryResult = Invoke-ADORestAPI @invokeParams
            $c, $t, $progId  = 0, $queryResult.workItems.count, [Random]::new().Next()
            $myParams = @{} + $PSBoundParameters
            $myParams.Remove('Query')
            foreach ($wi in $queryResult.workItems) {
                $c++
                Write-Progress "Updating Work Items" " [$c of $t]" -PercentComplete ($c * 100 /$t) -Id $progId
                Remove-ADOWorkItem @myParams -ID $wi.ID
            }

            Write-Progress "Updating Work Items" "Complete" -Completed -Id $progId
        }
        elseif ($psParameterSet -eq '/{Organization}/{Project}/_apis/wit/queries/{QueryID}') {                       
            $invokeParams.Method = "DELETE"            
            $invokeParams["Uri"] = "$Server".TrimEnd('/') + $psParameterSet
            $invokeParams.QueryParameter = @{"api-version"="$ApiVersion"}
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                return $invokeParams
            }
            Invoke-ADORestAPi @invokeParams
        }
    }
}
