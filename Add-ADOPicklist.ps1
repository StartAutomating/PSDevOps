function Add-ADOPicklist {
    <#
    .Synopsis
        Creates Picklists
    .Description
        Creates Picklists in Azure DevOps.
    .Example
        Add-ADOPicklist -Organization MyOrg -PicklistName TShirtSize -Item S, M, L, XL
    .Link
        Get-ADOPicklist
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/create
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('PSDevOps.Picklist.Detail')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired")]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The name of the picklist
    [Parameter(Mandatory,ParameterSetName='work/processes/lists')]
    [string]
    $PicklistName,

    # The data type of the picklist.  By default, String.
    [ValidateSet('Double','Integer','String')]
    [string]
    $DateType = 'String',

    # If set, will make the items in the picklist "suggested", and allow user input.
    [switch]
    $IsSuggested,
    
    # A list of items.  By default, these are the initial contents of the picklist.
    # If a PicklistID is provided, or -PicklistName already exists, will add these items to the picklist.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Value', 'Items','Values')]
    [string[]]
    $Item,

     # The PicklistID of an existing picklist.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='work/processes/lists/{PicklistId}')]
    [string]
    $PicklistID,

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
        $getPicklists = Get-ADOPicklist -Organization $Organization @invokeParams
        
        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).


            $picklistExists = $getPicklists | 
                Where-Object { $_.name -eq $PicklistName } | 
                Select-Object -First 1
            
            if ($picklistExists) {
                $PicklistID   = $picklistExists.ID
                $parameterSet = 'work/processes/lists/{PicklistId}'
            }


            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne '' -join '/'

            $c++
            Write-Progress "Adding" "[$c/$t] $uri" -Id $id -PercentComplete ($c * 100/$t)

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

            $invokeParams.Uri = $uri                        
            $invokeParams.Property = @{Organization=$Organization;Server=$Server}
            $invokeParams.PSTypeName = "$Organization.Picklist.Detail", 'PSDevOps.Picklist.Detail'

            if ($picklistExists) { # If the picklist exists, we're adding an item to an existing picklist.                
                $body = @{items=@($picklistExists.items + $Item  | Select-Object -Unique)}
                $invokeParams.Method  = 'PUT'
            } else {
                $invokeParams.Method  = 'POST'
                $body = @{
                    name = $PicklistName
                    type = $DateType
                }
                if ($Item) {
                    $body.items = @($Item)
                }
            }
            if ($PSBoundParameters.ContainsKey('IsSuggested')) {
                $body.isSuggested = $IsSuggested -as [bool]
            }
            $invokeParams.Body = $body

            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                $invokeParams
                continue
            }
            if (-not $psCmdlet.ShouldProcess("$($invokeParams.Method) $($invokeParams.uri)")) {continue }
            Invoke-ADORestAPI @invokeParams
        }

        Write-Progress "Adding" "[$c/$t]" -Id $id -Completed
    }
}


