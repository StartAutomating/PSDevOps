function New-ADOField
{
    <#
    .Synopsis
        Creates new fields in Azure DevOps
    .Description
        Creates new work item fields in Azure DevOps or Team Foundation Server.
    .Example
        New-ADOField -Name Verb -ReferenceName Cmdlet.Verb -Description "The PowerShell Verb" -ValidValue (Get-Verb | Select-Object -ExpandProperty Verb | Sort-Object)
    .Example
        New-ADOField -Name IsDCR -Type Boolean -Description "Is this a direct custom request?"
    .Link
        Invoke-ADORestAPI
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    # The friendly name of the field
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Alias('FriendlyName', 'DisplayName')]
    [string]
    $Name,

    # The reference name of the field.  This is the name used in queries.
    # If not provided, the ReferenceName will Custom. + -Name (stripped of whitespace)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('SystemName')]
    [string]
    $ReferenceName,

    <#
    The type of the field.

    This can be any of the following:
    * boolean
    * dateTime
    * double
    * guid
    * history
    * html
    * identity
    * integer
    * plainText
    * string
    * treePath
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('FieldType')]
    [ValidateSet('boolean','dateTime', 'double','guid',
        'history','html','identity','integer',
        'picklistDouble','picklistInteger','picklistString', 'plainText','string','treePath')]
    [string]
    $Type = 'string',

    # A description for the field.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # A list of valid values.
    # If provided, an associated picklist will be created with these values.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ValidValues','Picklist')]
    [string[]]
    $ValidValue,

    # If set, the field can be used to sort.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $CanSortBy,

    # If set, the field can be used in queries.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $IsQueryable,

    # If set, the field will be read only.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $ReadOnly,

    # If set, custom values can be provided into the field.
    # This is ignored if not used with -ValidValue.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('IsPickListSuggestable','OpenEnded')]
    [switch]
    $AllowCustomValue,

    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1")

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

        $validFieldTypes = foreach ($_ in $MyInvocation.MyCommand.Parameters['Type'].Attributes) {
            if ($_.ValidValues) { $_.ValidValues;break }
        }
    }

    process {
        $uriBase = "$Server".TrimEnd('/'), $Organization, $Project -join '/'

        $uri = $uriBase, "_apis/wit/fields?" -join '/'
        if ($Server -ne 'https://dev.azure.com/' -and 
            -not $PSBoundParameters.ApiVersion) {
            $ApiVersion = '2.0'
        }

        $uri +=
            if ($ApiVersion) {
                "api-version=$ApiVersion"
            }



        $postContent = [Ordered]@{}
        $postContent.name = $Name
        $postContent.referenceName =
            if ($ReferenceName) { $ReferenceName }
            else {
                "Custom." + $Name -replace '\s',''
            }



        $postContent.type = $validFieldTypes[$validFieldTypes.IndexOf($Type)]
        $postContent.readOnly = $readOnly -as [bool]
        $postContent.canSortBy = $canSortBy -as [bool]
        $postContent.isQueryable = $isQueryable -as [bool]
        $postContent.isIdentity = $type -eq 'identity'
        $postContent.description = $Description

        if ($ValidValue) {
            if ($Type -ne 'string' -and $type -ne 'integer' -and $type -ne 'double') {
                Write-Error "Can only provide a list of valid values fields of type string, integer, or double"
                return
            }
            $postContent.isPicklist = $true
            $pickListCreate = [Ordered]@{
                id = $null
                name = "$($postContent.ReferenceName)_$([GUID]::NewGuid())" -replace '-','' -replace '\.',''
                type = $validFieldTypes[$validFieldTypes.IndexOf($Type)]
            }
            $pickListCreate.type= $pickListCreate.type.Substring(0,1).ToUpper() + $pickListCreate.type.Substring(1)
            $pickListCreate.items =
                if ($type -eq 'string') {
                    $ValidValue
                } else {
                    $ValidValue -as [double[]]
                }
            $picklistCreateUri = "$Server".TrimEnd('/'), $Organization, '_apis/work/processes/lists?' -join '/'
            if ($ApiVersion) {
                $picklistCreateUri += "api-version=$ApiVersion"
            }

            $createdPickList = Invoke-ADORestAPI @invokeParams -Uri $picklistCreateUri -Method POST -Body $pickListCreate
            $postContent.picklistId = $createdPickList.id
            $postContent.isPicklistSuggest = $AllowCustomValue -as [bool]
        }
        $invokeParams.Uri = $uri
        $invokeParams.Body = ConvertTo-Json $postContent -Depth 100
        $invokeParams.Method = 'POST'
        if (-not $PSCmdlet.ShouldProcess("POST $uri with $($invokeParams.body)")) { return }
        Invoke-ADORestAPI @invokeParams -PSTypeName "PSDevOps.Field" -Property @{
            Organization = $Organization
            Project = $Project
            Server = $Server
        }
    }
}