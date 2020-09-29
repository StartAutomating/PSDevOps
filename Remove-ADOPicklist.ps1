function Remove-ADOPicklist {
    <#
    .Synopsis
        Removes Picklists and Widgets
    .Description
        Removes Picklists from Azure DevOps, or Removes Widgets from a Picklist in Azure Devops.
    .Example
        Get-ADOPicklist -Organization MyOrg -Orphan | Remove-ADOPicklist
    .Link
        Get-ADOPicklist
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/delete
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    [OutputType([Nullable], [Hashtable])]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The PicklistID.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='work/processes/lists/{PicklistId}')]
    [string]
    $PicklistID,

    # A list of items to remove.
    # If this parameter is provided, the picklist items will be removed, and the picklist will not be deleted.
    # If this parameter is not provided, the picklist will not be deleted.
    [Parameter(ParameterSetName='work/processes/lists/{PicklistId}')]
    [Alias('Value', 'Items','Values')]
    [string[]]
    $Item,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

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
        $ParameterSet = $psCmdlet.ParameterSetName
        $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).


            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne ''  -join '/'

            $uri += '?' # The URI has a query string containing:
            $uri += @(
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'

            $c++
            Write-Progress "Removing $($Item -join ' ')" "[$c/$t] $uri" -Id $id -PercentComplete ($c * 100/$t)

            $invokeParams.Uri = $uri
            
            if ($Item) {
                $invokeParams.Method = 'PUT'
                $getPicklistSplat = @{} + $DequedInput
                $getPicklistSplat.Remove('ParameterSet')
                $getPicklistSplat.Remove('Name')
                $getPicklistSplat.Remove('Item')
                $picklistItems = Get-ADOPicklist @getPicklistSplat
                $picklistItems.items  = @(
                    $picklistItems.items |
                        Where-Object {
                            foreach ($i in $item) {
                                if ( $_ -like $i) { return }
                            }
                            $_
                        })
                $invokeParams.body = $picklistItems
                $invokeParams.pstypename = "$Organization.Picklist.Detail", "PSDevOps.Picklist.Detail"
            } else {
                $invokeParams.Method  = 'DELETE'                
            }
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("$($invokeParams.Method) $($item -join ' ') $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Removing $($Item -join ' ')" "[$c/$t]" -Id $id -Completed
    }
}


