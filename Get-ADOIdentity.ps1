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
        Get-ADOIdentity -Organization StartAutomating
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

    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('AcesDictionary')]
    [PSObject]
    $AceDictionary,

    # A list of descriptors
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Members')]
    [string[]]
    $Descriptors,
    
    # If set, will get membership information.
    [switch]
    $Membership,    

    [string]
    $Filter,

    [ValidateSet('AccountName','DisplayName','MailAddress','General','LocalGroupName')]
    [string]
    $SearchType = 'General',

    # The api version.  By default, 6.0.
    # This API does not exist in TFS.
    [string]
    $ApiVersion = "6.0"
    )

    dynamicParam { . $GetInvokeParameters -DynamicParameter }

    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
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

        $uri += '?' # The URI has a query string containing:
        $uri += @(
            if ($AceDictionary) {
                $Descriptors += $AceDictionary.psobject.Properties | Select-Object -ExpandProperty Name
            }
            if ($Descriptors) {
                "descriptors=$($Descriptors -join ',')"
            }
            if ($Filter) {
                "searchFilter=$SearchType"
            }
            if ($Filter) {
                "filterValue=$([Web.HttpUtility]::UrlEncode($Filter).Replace('+','%20'))"
            }
            if ($Membership) {
                "queryMembership=Direct"
            }
            if ($ApiVersion) { # the api-version
                "api-version=$apiVersion"
            }
        ) -join '&'
        
        # We want to decorate our return value.  .
        $typename = 'Identity' # We just need to drop the 's'

        $typeNames = @(
            "$organization.$typename"
            "PSDevOps.$typename"
        )


        $invokeParams.Uri = $uri
        $invokeParams.PSTypeName = $typeNames
        $invokeParams.Property = @{Organization=$Organization;Server=$Server}


        Invoke-ADORestAPI @invokeParams
    }
}

