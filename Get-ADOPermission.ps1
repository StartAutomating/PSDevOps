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
    .Link
        https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference
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
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Project')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Tagging')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ManageTFVC')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildPermission')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='RepositoryID')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectRepository')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectOverview')]
    [Alias('Project')]
    [string]
    $ProjectID,

    # If set, will get common permissions related to a project.
    # These are:
    # * Builds
    # * Boards
    # * Dashboards
    # * Git Repositories
    # * ServiceEndpoints
    # * Project Permissions
    # * Service Endpoints
    # * ServiceHooks
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectOverview')]
    [Alias('ProjectOverview')]
    [switch]
    $Overview,

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

    # If set, will expand the ACE dictionary returned
    [Alias('ACL')]
    [switch]
    $ExpandACL,

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

        $innerInvokeParams = @{} + $invokeParams
        $innerInvokeParams.Remove('AsJob')
        $innerInvokeParams.Remove('ExpandACL')
    }

    process {
        $ParameterSet = $psCmdlet.ParameterSetName

        if ($psCmdlet.ParameterSetName -notin 'securitynamespaces', 'accesscontrollists/{NamespaceId}') {
            $in = $_
            $PSBoundParameters['InputObject'] = $in
            $PSBoundParameters['FriendlyName'] = $psCmdlet.ParameterSetName
            if ($ProjectID -and -not ($ProjectID -as [guid])) {
                $oldProgressPref = $ProgressPreference; $ProgressPreference = 'silentlycontinue'
                $projectID = Get-ADOProject -Organization $Organization -Project $projectID | Select-Object -ExpandProperty ProjectID
                $ProgressPreference = $oldProgressPref
                if (-not $ProjectID) { return }
            }
            switch -Regex ($psCmdlet.ParameterSetName)  {
                Project {
                    $null = $PSBoundParameters.Remove('ProjectID')
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '52d39943-cb85-4d7f-8fa8-c6baac873819'
                        SecurityToken = "`$PROJECT:vstfs:///Classification/TeamProject/$ProjectID"
                    } + $PSBoundParameters)
                }
                ProjectOverview {
                    $null = $psboundParameters.Remove('Recurse')
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '52d39943-cb85-4d7f-8fa8-c6baac873819' # Project permissions
                        SecurityToken = "`$PROJECT:vstfs:///Classification/TeamProject/$ProjectID"
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87' # Repositories
                        SecurityToken = "reposV2/$projectId"
                        Recurse = $true
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '33344d9c-fc72-4d6f-aba5-fa317101a7e9' # Build definitions
                        SecurityToken = "$ProjectID/"
                        Recurse = $true
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = 'c788c23e-1b46-4162-8f5e-d7585343b5de' # Releases
                        SecurityToken = "$ProjectID/"
                        Recurse = $true
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '8adf73b7-389a-4276-b638-fe1653f7efc7' # Dashboards
                        SecurityToken = "`$/$ProjectID/"
                        Recurse = $true
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = '49b48001-ca20-4adc-8111-5b60c903a50c' # Service Endpoints
                        SecurityToken = "endpoints/$ProjectID"
                        Recurse = $true
                    } + $PSBoundParameters)
                    $q.Enqueue(@{
                        ParameterSet='accesscontrollists/{NamespaceId}'
                        NamespaceID = 'cb594ebe-87dd-4fc9-ac2c-6a10a4c92046' # Service Hooks
                        SecurityToken = "PublisherSecurity/$ProjectID"
                        Recurse = $true
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

        if ($ExpandACL) {

            $resolveIdentity = {
                param([Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$Descriptor)
                begin {
                    if (-not $script:ResolvedIdentities) { $script:ResolvedIdentities= @{} }
                }
                process {
                    if (-not $script:ResolvedIdentities[$Descriptor]) {
                        $script:ResolvedIdentities[$Descriptor] =
                            Invoke-ADORestAPI "https://vssps.dev.azure.com/$Organization/_apis/identities?api-version=6.0&descriptors=$Descriptor&queryMembership=Direct"
                    }
                    return $script:ResolvedIdentities[$Descriptor]
                }
            }
        }

        if ($Overview -and $inputObject) {
            $projectRepositories     = $inputObject | Get-ADORepository
            $projectServiceEndpoints = $inputObject | Get-ADOServiceEndpoint
            $projectServiceHooks     = $inputObject | Get-ADOServiceHook
            $projectBuildDefinitions = $inputObject | Get-ADOBuild -Definition
            $projectBoards           = $inputObject | Get-ADOProject -Board
        }

        if ($ParameterSet -ne 'securitynamespaces') {
            $namespaceList = Get-ADOPermission @innerInvokeParams -Organization $Organization
        }

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).



            $c++
            $getProgressMessage =
                if ($friendlyName) {
                    $friendlyName
                } else {
                    $(@($ParameterSet -split '/' -notlike '{*}')[-1])
                }

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/')   # the Server (minus any trailing slashes),
                    $Organization            # the Organization,
                    '_apis'                  # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $ParameterSet)
                                             # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne ''  -join '/'

            Write-Progress "Getting $getProgressMessage" $(
                if ($parameterSet -eq 'accesscontrollists/{NamespaceId}') {
                    '' + $(foreach ($ns in $namespaceList) {
                        if ($ns.NamespaceId -eq $NamespaceID) { $ns.Name ; break }
                    }) + ' ' + $SecurityToken
                } else {
                    "$uri"
                }) -Id $progId -PercentComplete ($c * 100/$t)


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
                "PSDevOps.$typename"
            )

            $additionalProperties = @{Organization=$Organization;Server=$Server}
            if ($ParameterSet -eq 'accesscontrollists/{NamespaceId}') {
                $additionalProperties['NamespaceID']   = $NamespaceID
                $additionalProperties['NamespaceName'] =
                    foreach ($ns in $namespaceList) {
                        if ($ns.NamespaceId -eq $NamespaceID) { $ns.Name; break }
                    }
            }
            if ($inputObject) {
                $additionalProperties['InputObject'] = $inputObject
            }

            $invokeParams.Uri = $uri
            $invokeParams.Property = $additionalProperties
            $invokeParams.PSTypeName = $typenames

            if ($ExpandACL) {
                $cachedIds = @{}
                Invoke-ADORestAPI @invokeParams |
                    & { process  {
                        $inObj = $_
                        $aces =  $inObj.acesDictionary
                        $aceList = $inObj.acesDictionary.psobject.properties.name -join ','
                        if (-not $cachedIds[$aceList]) {
                            $cachedIds[$aceList] = @($inObj | Get-ADOIdentity -Membership)
                        }
                        $expandedIdentities = $cachedIds[$aceList]
                        $inObj.psobject.properties.Remove('acesDictionary')
                        $namespace =
                            foreach ($ns in $namespaceList) {
                                if ($ns.NamespaceId -eq $inObj.namespaceID) { $ns; break }
                            }

                        $c = 0
                        foreach ($prop in $aces.psobject.properties) {
                            $aclOut = [Ordered]@{}
                            $resolvedId = $expandedIdentities[$c]
                            $c++


                            $aclOut.IsReader = [bool]($prop.value.allow -band $namespace.readPermission)
                            $aclOut.IsWriter = [bool]($prop.value.allow -band $namespace.writePermission)
                            $aclOut.IsAdmin  = [bool]($prop.value.allow -band $namespace.systemBitmask)
                            $aclOut.Allow = $namespace.ConvertFromBitmask($prop.value.allow)
                            $aclOut.Deny  = $namespace.ConvertFromBitmask($prop.value.deny)
                            $aclOut.Descriptor = $prop.Name
                            foreach ($inProp in $inObj.psobject.properties) {
                                $aclOut[$inProp.Name] = $inProp.Value
                            }
                            $aclOut.NamespaceName  = $namespace.Name
                            if ($Overview) {
                                $aclOut.Target =
                                    switch ($namespace.Name) {
                                        Project { $inputObject }
                                        'Git Repositories' {
                                            foreach ($repo in $ProjectRepository) {
                                                if ($aclOut.Token -like "*/$($repo.id)*") {
                                                    $repo;break
                                                }
                                            }
                                        }
                                        Boards {
                                            foreach ($board in $projectBoards) {
                                                if ($aclOut.Token -like "*$($board.id)*") {
                                                    $board;break
                                                }
                                            }
                                        }
                                        "Build|ReleaseManagement" {
                                            foreach ($def in $projectBuildDefinitions) {
                                                if ($aclOut.Token -like "*/$($def.id)*") {
                                                    $def;break
                                                }
                                            }
                                        }
                                        ServiceHooks {
                                            foreach ($svc in $projectServiceHooks) {
                                                if ($aclOut.Token -like "*/$($svc.id)*") {
                                                    $svc;break
                                                }
                                            }
                                        }
                                        ServiceEndpoints {
                                            foreach ($svc in $projectServiceEndpoints) {
                                                if ($aclOut.Token -like "*/$($svc.id)*") {
                                                    $svc;break
                                                }
                                            }
                                        }
                                    }




                            }


                            $resolvedIds = @()

                            # Resolving group membership without resolving it recursively is less helpful,
                            # but still helpful, so leave this alone for now
                            $aclOut.Group =
                                if ($resolvedId.members) {
                                    if ($resolvedID.customDisplayName) { $resolvedID.customDisplayName }
                                    elseif ($resolvedID.providerDisplayName) { $resolvedID.providerDisplayName }
                                    else { $resolvedID.descriptor }

                                    $memberAceList = $resolvedID.members -join ','
                                    if (-not $cachedIds[$memberAceList]) {
                                        $cachedIds[$memberAceList] = @(Get-ADOIdentity -Organization $organization -Descriptors $resolvedID.members -Recurse -Membership)
                                    }
                                    $resolvedIds = $cachedIds[$memberAceList]
                                } else {
                                    $resolvedIds =@($resolvedID)
                                }


                            foreach ($resolvedId in $resolvedIds) {
                                $aclOut.IsGroup = $resolvedId.properties.SchemaClassName -eq 'Group'
                                $aclOut.Identity =
                                    if ($resolvedID.customDisplayName) { $resolvedID.customDisplayName }
                                    elseif ($resolvedID.providerDisplayName) { $resolvedID.providerDisplayName }
                                    else { $resolvedID.descriptor }

                                $out = [PSCustomObject]$aclOut
                                $out.pstypenames.clear()
                                $out.pstypenames.add("PSDevOps.AccessControlEntry")
                                $out.pstypenames.add("$Organization.AccessControlEntry")
                                $out
                            }
                        }
                    } }
            } else {

                if ($psCmdlet.ParameterSetName -eq 'securitynamespaces' -and
                    -not $invokeParams.AsJob) {
                    if (-not $script:CachedSecurityNamespaces) {
                        $script:CachedSecurityNamespaces = Invoke-ADORestAPI @invokeParams
                    }
                    $script:CachedSecurityNamespaces
                } else {
                    Invoke-ADORestAPI @invokeParams -DecorateProperty @{
                        AcesDictionary = "$Organization.ACEDictionary", "PSDevOps.ACEDictionary"
                    }
                }
            }
        }

        Write-Progress "Getting $($ParameterSet)" "$server $Organization $Project" -Id $progId -Completed
    }
}