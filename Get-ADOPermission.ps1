function Get-ADOPermission
{
    <#
    .Synopsis
        Gets Azure DevOps Permissions
    .Description
        Gets Azure DevOps security permissions.
    .Example
        Get-ADOPermission -Organization MyOrganization -Project MyProject -PersonalAccessToken $pat
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20lists/query
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/security/security%20namespaces/query
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    [OutputType('PSDevOps.SecurityNamespace', 'PSDevOps.AccessControlList')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # If set, will list the type of permisssions.
    [Parameter(ParameterSetName='securitynamespaces')]
    [Alias('SecurityNamespace', 'ListPermissionType','ListSecurityNamespace')]
    [switch]
    $PermissionType,

    # The Security Namespace ID.  
    # For details about each namespace, see: 
    # https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrollists/{NamespaceId}')]
    [string]
    $NamespaceID,

    # The Security Token.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='accesscontrollists/{NamespaceId}')]
    [string]
    $SecurityToken,

    # The Project ID.
    # If this is provided without anything else, will get permissions for the projectID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectID')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Tagging')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ManageTFVC')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildPermission')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='RepositoryID')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectRepository')]
    [Alias('Project')]
    [string]
    $ProjectID,

    # If set, will get permissions for tagging related to the current project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Tagging')]
    [switch]
    $Tagging,

    # If set, will get permissions for tagging related to the current project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ManageTFVC')]
    [switch]
    $ManageTFVC,

    # The Build Definition ID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]
    [string]
    $DefinitionID,

    # The path to the build.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]    
    [string]
    $Path ='/',

    # If set, will get build and release permissions for a given project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildPermission')]
    [switch]
    $BuildPermission,

    # If provided, will get build and release permissions for a given project's repositoryID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='RepositoryID')]
    [string]
    $RepositoryID,

    # If set, will get permissions for repositories within a project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectRepository')]
    [Alias('ProjectRepositories')]
    [switch]
    $ProjectRepository,

    # If set, will get permissions for repositories within a project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='AllRepositories')]    
    [Alias('AllRepositories')]
    [switch]
    $AllRepository,

    # The Descriptor
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Descriptor,

    # If set and this is a hierarchical namespace, return child ACLs of the specified token.
    [Parameter(ValueFromPipelineByPropertyName)]    
    [switch]
    $Recurse,

    # If set, populate the extended information properties for the access control entries in the returned lists.
    [Parameter(ValueFromPipelineByPropertyName)]    
    [switch]
    $IncludeExtendedInfo,

    # The server.  By default https://dev.azure.com/.
    # To use against TFS, provide the tfs server URL (e.g. http://tfsserver:8080/tfs).
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    # If targeting TFS, this will need to change to match your server version.
    # See: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops
    [string]
    $ApiVersion = "5.1-preview")
    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
        $q = [Collections.Queue]::new()
    }

    process {
        $ParameterSet = $psCmdlet.ParameterSetName

        if ($psCmdlet.ParameterSetName -notin 'securitynamespaces', 'accesscontrollists/{NamespaceId}') {
            $in = $_
            if ($ProjectID -and -not ($ProjectID -as [guid])) { 
                $oldProgressPref = $ProgressPreference; $ProgressPreference = 'silentlycontinue'
                $projectID = Get-ADOProject -Organization $Organization -Project $projectID | Select-Object -ExpandProperty ProjectID
                $ProgressPreference = $oldProgressPref
                if (-not $ProjectID) { return }
            }
            switch -Regex ($psCmdlet.ParameterSetName)  {
                ProjectID {                    
                    $null = $PSBoundParameters.Remove('ProjectID')
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '52d39943-cb85-4d7f-8fa8-c6baac873819'
                        SecurityToken = "`$PROJECT:vstfs:///Classification/TeamProject/$ProjectID"
                    } + $PSBoundParameters)
                }
                Tagging {
                    
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = 'bb50f182-8e5e-40b8-bc21-e8752a1e7ae2'
                        SecurityToken = "/$ProjectID"
                    } + $PSBoundParameters)
                }
                ManageTFVC {
                    
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = 'a39371cf-0841-4c16-bbd3-276e341bc052'
                        SecurityToken = "/$ProjectID"
                    } + $PSBoundParameters)
                }
                'BuildDefinition|BuildPermission' {
                    
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = 'a39371cf-0841-4c16-bbd3-276e341bc052'
                        SecurityToken = "$ProjectID$(($path -replace '\\','/').TrimEnd('/'))/$DefinitionID"
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = 'c788c23e-1b46-4162-8f5e-d7585343b5de'
                        SecurityToken = "$ProjectID$(($path -replace '\\','/').TrimEnd('/'))/$DefinitionID"
                    } + $PSBoundParameters)                    
                }
                'RepositoryID|AllRepositories|ProjectRepository' {
                    
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87'
                        SecurityToken = "repo$(
if ($psCmdlet.ParameterSetName -eq 'AllRepositories') {'s'})V2$(
if ($ProjectID) { '/' + $projectId}
)$(
if ($repositoryID) {'/' + $repositoryID}
)"
                    } + $PSBoundParameters)
                }
            }            
            return
        }
        $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
    }
    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).


            $c++
            Write-Progress "Getting $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$server $Organization $Project" -Id $progId -PercentComplete ($c * 100/$t)

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
                if ($ParameterSet -eq 'accesscontrollists/{NamespaceId}') {
                    if ($Recurse) { 'recurse=true' }
                    if ($includeExtendedInfo) { 'includeExtendedInfo=true' }
                    if ($SecurityToken) { "token=$SecurityToken"}
                    if ($Descriptor) { "descriptors=$($Descriptor -join ',')"}
                }
                if ($Server -ne 'https://dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # the api-version
                    "api-version=$apiVersion"
                }
            ) -join '&'

            # We want to decorate our return value.  Handily enough, both URIs contain a distinct name in the last URL segment.
            $typename = @($parameterSet -split '/' -notlike '{*}')[-1].TrimEnd('s') # We just need to drop the 's'
            $typeNames = @(
                "$organization.$typename"
                if ($Project) { "$organization.$Project.$typename" }
                "PSDevOps.$typename"
            )

            $additionalProperties = @{Organization=$Organization;Server=$Server}
            if ($ParameterSet -eq 'accesscontrollists/{NamespaceId}') {
                $additionalProperties['NamespaceID'] = $NamespaceID
            }
            Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property $additionalProperties
        }

        Write-Progress "Getting $($ParameterSet)" "$server $Organization $Project" -Id $progId -Completed
    }
}