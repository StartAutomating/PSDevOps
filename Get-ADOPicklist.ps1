function Get-ADOPicklist
{
    <#
    .Synopsis
        Gets picklists from Azure DevOps.
    .Description
        Gets picklists from Azure DevOps.
        
        Picklists are lists of values that can be associated with a field, for example, a list of T-shirt sizes.
    .Example
        Get-ADOPicklist -Organization StartAutomating -PersonalAccessToken $pat
    .Example
        Get-ADOPicklist -Organization StartAutomating
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/list
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/processes/lists/get
    #>
    [OutputType('PSDevOps.Project','PSDevOps.Property')]
    [CmdletBinding(DefaultParameterSetName='work/processes/lists')]
    param(
    # The Organization
    [Parameter(Mandatory,ParameterSetName='work/processes/lists',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='work/processes/lists/{PickListID}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='Orphan')]
    [Alias('Org')]
    [string]
    $Organization,

    # The Picklist Identifier.
    [Parameter(Mandatory,ParameterSetName='work/processes/lists/{PickListID}',ValueFromPipelineByPropertyName)]
    [string]
    $PickListID,

    # The name of the picklist
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PicklistName = '*',

    # If set, will return orphan picklists.  These picklists are not associated with any field.
    [Parameter(Mandatory,ParameterSetName='Orphan')]
    [switch]
    $Orphan,

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
        if ($Orphan) {
            $allPicklists     = Get-ADOPicklist -Organization $organization
            $allUsedPicklists = Get-ADOField @invokeParams -Organization $Organization |
                Where-Object { $_.IsPicklist } |
                Select-Object -ExpandProperty PicklistID
            $allPicklists  | 
                Where-Object PicklistID -NotIn $allUsedPicklists
            return 
        }

        $in = $_
        $psParameterSet = $psCmdlet.ParameterSetName
        $q.Enqueue(@{PSParameterSet=$psParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $dq $q
            
            $uri =
                "$(@(

                    "$server".TrimEnd('/')  # * The Server
                    $Organization
                    '_apis'
                    . $ReplaceRouteParameter $psParameterSet #* and the replaced route parameters.
                )  -join '/')?$( # Followed by a query string, containing
                @(
                    if ($Server -ne 'https://dev.azure.com' -and
                            -not $psBoundParameters['apiVersion']) {
                        $apiVersion = '2.0'
                    }
                    if ($ApiVersion) { # an api-version (if one exists)
                        "api-version=$ApiVersion"
                    }
                ) -join '&'
                )"
            $c++ 
            Write-Progress "Getting" "[$c/$t] $uri" -PercentComplete ($c * 100 / $t) -Id $progId
            

            $typeName = @($psParameterSet -split '/' -notlike '{*}')[-1] -replace
                's$', '' -replace 'list', 'Picklist'

            if ($psParameterSet -like '*/{PicklistId}') {
                $typeName = "PickList.Detail"
            }

            $additionalProperty = @{
                Organization = $Organization
                Server = $Server
            }
            Invoke-ADORestAPI @invokeParams -uri $uri -PSTypeName "$Organization.$typeName",
                "PSDevOps.$typeName" -Property $additionalProperty |
                Where-Object { $_.Name -like $PicklistName }
        }

        Write-Progress "Getting" "[$t/$t]" -Completed -Id $progId
    }
}
