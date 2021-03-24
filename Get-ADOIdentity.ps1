function Get-ADOIdentity
{
    <#
    .Synopsis
        Gets Azure DevOps Identities
    .Description
        Gets Identities from Azure Devops.  Identities can be either users or groups.
    .Link
        Get-ADOUser
    .Link
        Get-ADOTeam
    .Example
        Get-ADOIdentity -Organization StartAutomating -Filter 'GitHub'
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/ims/identities/read%20identities
    #>
    [CmdletBinding(DefaultParameterSetName='identities')]
    [OutputType('PSDevOps.Team','PSDevOps.TeamMember')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # A dictionary of Access Control Entries
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('AcesDictionary')]
    [PSObject]
    $AceDictionary,

    # A list of descriptors
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Members')]
    [string[]]
    $Descriptors,

    # The maximum number of specific descriptors to request in one batch.
    [int]
    $DescriptorBatchSize = 50,

    # If set, will get membership information.
    [switch]
    $Membership,

    # If set, will recursively expand any group memberships discovered.
    [switch]
    $Recurse,

    # The filter used for a query
    [string]
    $Filter,

    # The search type.  Can be:  AccountName, DisplayName, MailAddress, General, LocalGroupName
    [ValidateSet('AccountName','DisplayName','MailAddress','General','LocalGroupName')]
    [string]
    $SearchType = 'General',

    # The api version.  By default, 6.0.
    # This API does not exist in TFS.
    [string]
    $ApiVersion = "6.0"
    )

    dynamicParam { Invoke-ADORestApi -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = Invoke-ADORestApi -MapParameter $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $psParameterSet = $psCmdlet.ParameterSetName

        $server = "https://vssps.dev.azure.com"


        $uri = # The URI is comprised of:
            @(
                $server                  # the Server (minus any trailing slashes),
                $Organization            # the Organization,
                '_apis'                  # the API Root ('_apis'),
                (. $ReplaceRouteParameter $psParameterSet)
                                         # and any parameterized URLs in this parameter set.
            ) -as [string[]] -ne '' -join '/'
        if ($Recurse) { $Membership = $true }
        $uri += '?' # The URI has a query string containing:
        # We want to decorate our return value.  .
        $typename = 'Identity' # We just need to drop the 's'

        $typeNames = @(
            "$organization.$typename"
            "PSDevOps.$typename"
        )
        $invokeParams.Uri = $uri
        $invokeParams.PSTypeName = $typeNames
        $invokeParams.Property = @{Organization=$Organization}
        if ($AceDictionary) {
            $Descriptors += $AceDictionary.psobject.Properties | Select-Object -ExpandProperty Name
            $null = $psBoundParameters.Remove('AceDictionary')
        }

        $invokeParamsList = @(
        if ($Descriptors -and $Descriptors.Length -gt $DescriptorBatchSize) {
            for ($i = 0; $i -lt $Descriptors.Length; $i+=$DescriptorBatchSize) {
                $descriptorBatch = $Descriptors[$i..($i + $DescriptorBatchSize - 1)]
            }
            $invokeCopy = @{} + $invokeParams
            $invokeCopy.Uri = $uri + (@(                
                if ($Descriptors) {
                    "descriptors=$($descriptorBatch -join ',')"
                }
                if ($Membership) { "queryMembership=Direct" }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&')
            $invokeCopy
        } else {
            $uri += @(
                if ($AceDictionary) {
                    $Descriptors += $AceDictionary.psobject.Properties | Select-Object -ExpandProperty Name
                    $null = $psBoundParameters.Remove('AceDictionary')
                }
                if ($Descriptors) {
                    "descriptors=$($Descriptors -join ',')"
                }
                if ($Filter) {
                    "searchFilter=$SearchType"
                    "filterValue=$([Web.HttpUtility]::UrlEncode($Filter).Replace('+','%20'))"
                }
                if ($Membership) {
                    "queryMembership=Direct"
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'
            $invokeParams.Uri = $uri
            $invokeParams
        })


        foreach ($ip in $invokeParams) {
            if (-not $recurse) {
                Invoke-ADORestAPI @ip
            } else {
                $ip.Cache = $true
                Invoke-ADORestAPI @ip|
                    Foreach-Object {
                        $_
                        if ($_.Members) {
                            $paramCopy = @{} + $psBoundParameters
                            $paramCopy['Descriptors'] = $_.members
                            $paramCopy.Remove('Filter')
                            Get-ADOIdentity @paramCopy
                        }
                    }
            }
        }
    }
}

