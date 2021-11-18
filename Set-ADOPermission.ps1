function Set-ADOPermission
{
    <#
    .Synopsis
        Sets Azure DevOps Permissions
    .Description
        Gets Azure DevOps security permissions.
    .Example
        Set-ADOPermission -Organization MyOrganization -Project MyProject -PersonalAccessToken $pat
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/security/access%20control%20entries/set%20access%20control%20entries
    .Link
        https://docs.microsoft.com/en-us/azure/devops/organizations/security/namespace-reference
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("Test-ForParameterSetAmbiguity", "", Justification="Ambiguity Desired.")]
    [OutputType('PSDevOps.SecurityNamespace', 'PSDevOps.AccessControlList')]
    param(
    # The Organization.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project ID.
    # If this is provided without anything else, will get permissions for the projectID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Project')]
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Analytics')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='AreaPath')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Dashboard')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='IterationPath')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Tagging')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ManageTFVC')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildPermission')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='RepositoryID')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectRepository')]    
    [Alias('Project')]
    [string]
    $ProjectID,

    # If provided, will set permissions related to a given teamID. ( see Get-ADOTeam)
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Dashboard')]
    [string]
    $TeamID,

    # If provided, will set permissions related to an Area Path. ( see Get-ADOAreaPath )
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='AreaPath')]
    [string]
    $AreaPath,

    # If provided, will set permissions related to an Iteration Path. ( see Get-ADOIterationPath )
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='IterationPath')]
    [string]
    $IterationPath,

    # The Build Definition ID
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]
    [string]
    $DefinitionID,

    # The path to the build.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='BuildDefinition')]
    [string]
    $BuildPath ='/',

    # If set, will set build and release permissions for a given project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='BuildPermission')]
    [switch]
    $BuildPermission,

    # If set, will set permissions for repositories within a project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ProjectRepository')]
    [Alias('ProjectRepositories')]
    [switch]
    $ProjectRepository,

    # If provided, will set permissions for a given repositoryID    
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='RepositoryID')]
    [string]
    $RepositoryID,

    # If provided, will set permissions for a given branch within a repository    
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='RepositoryID')]
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='AllRepositories')]
    [string]
    $BranchName,

    # If set, will set permissions for all repositories within a project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='AllRepositories')]
    [Alias('AllRepositories')]
    [switch]
    $AllRepository,

    # If set, will set permissions for tagging related to the current project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Tagging')]
    [switch]
    $Tagging,

    # If set, will set permissions for Team Foundation Version Control related to the current project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ManageTFVC')]
    [switch]
    $ManageTFVC,

        # If set, will get permissions for Delivery Plans.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Plan')]
    [switch]
    $Plan,

    # If set, will get dashboard permissions related to the current project.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Dashboard')]
    [Alias('Dashboards')]
    [switch]
    $Dashboard,
    
    # If set, will list the type of permisssions.
    [Parameter(ParameterSetName='securitynamespaces')]
    [Alias('SecurityNamespace', 'ListPermissionType','ListSecurityNamespace')]
    [switch]
    $PermissionType,

    # The Security Namespace ID.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [string]
    $NamespaceID,

    # The Security Token.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [string]
    $SecurityToken,

    # One or more descriptors
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [string[]]
    $Descriptor,

    # One or more identities.  Identities will be converted into descriptors.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Identity,

    # One or more allow permissions.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Allow,

    # One or more deny permissions.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Deny,

    # If set, will overwrite this entry with existing entries.
    # By default, will merge permissions for the specified token.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('NoMerge')]
    [switch]
    $Overwrite,

    # If set, will inherit this permissions.
    # By permissions will not be inherited.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('InheritPermission','InheritPermissions')]
    [switch]
    $Inherit,

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

        $cachedNamespaces = @{}
        $originalInvokeParams = @{} + $invokeParams

        $resolveIdentity = {
            param(
            [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
            [string]$Identity)

            begin {
                if (-not $script:CachedIdentities) { $script:CachedIdentities = @{}}
            }

            process {
                if (-not $script:CachedIdentities[$Identity]) {
                    $searchUri =
                        "https://vssps.dev.azure.com/$Organization/_apis/identities?api-version=6.0&searchfilter=General&filterValue=$Identity"
                    $script:CachedIdentities[$Identity] = Invoke-ADORestAPI -Uri $searchUri
                }
                $script:CachedIdentities[$Identity]
            }
        }
    }

    process {
        $ParameterSet = $psCmdlet.ParameterSetName
        if ($psCmdlet.ParameterSetName -notin 'securitynamespaces', 'accesscontrolentries/{NamespaceId}') {
            if ($ProjectID -and -not ($ProjectID -as [guid])) {
                $oldProgressPref = $ProgressPreference; $ProgressPreference = 'silentlycontinue'
                $projectID = Get-ADOProject -Organization $Organization -Project $projectID | Select-Object -ExpandProperty ProjectID
                $ProgressPreference = $oldProgressPref
                if (-not $ProjectID) { return }
            }
            $psBoundParameters['ParameterSet']='accesscontrolentries/{NamespaceId}'
            switch -Regex ($psCmdlet.ParameterSetName) {
                Project {
                    $null = $PSBoundParameters.Remove('ProjectID')
                    $q.Enqueue(@{                        
                        NamespaceID = '52d39943-cb85-4d7f-8fa8-c6baac873819'
                        SecurityToken = "`$PROJECT:vstfs:///Classification/TeamProject/$ProjectID"
                    } + $PSBoundParameters)
                }
                Analytics {
                    $null = $PSBoundParameters.Remove('ProjectID')
                    $q.Enqueue(@{                        
                        NamespaceID = if ($ProjectID) { '58450c49-b02d-465a-ab12-59ae512d6531' } else { 'd34d3680-dfe5-4cc6-a949-7d9c68f73cba'} 
                        SecurityToken = "`$/$(if ($ProjectID) { $ProjectID } else { 'Shared' })"
                    } + $PSBoundParameters)
                }
                'AreaPath|IterationPath' {
                    $gotPath =
                        if ($psCmdlet.ParameterSetName -eq 'AreaPath') {
                            Get-ADOAreaPath -Organization $Organization -Project $ProjectID -AreaPath $AreaPath
                        } else {
                            Get-ADOIterationPath -Organization $Organization -Project $ProjectID -IterationPath $iterationPath
                        }
                        
                    if (-not $gotPath) {
                        continue
                    }
                    $PathIdList = @(
                        $gotPath.Identifier
                        $parentUri = $gotPath._links.parent.href
                        while ($parentUri) {
                            $parentPath = Invoke-ADORestAPI -Uri $parentUri
                            $parentPath.identifier
                            $parentUri = $parentPath._links.parent.href
                        }
                    )

                    [Array]::Reverse($PathIdList)
                                        
                    $null = $PSBoundParameters.Remove('ProjectID')
                    
                    $q.Enqueue(@{                        
                        NamespaceID = 
                            if ($psCmdlet.ParameterSetName -eq 'AreaPath') { 
                                '83e28ad4-2d72-4ceb-97b0-c7726d5502c3'
                            } else {
                                'bf7bfa03-b2b7-47db-8113-fa2e002cc5b1'    
                            }
                        SecurityToken = @(foreach($PathId in $PathIdList) {
                            "vstfs:///Classification/Node/$PathId"
                        }) -join ':'
                    } + $PSBoundParameters)
                }
                Dashboard {
                    $null = $PSBoundParameters.Remove('ProjectID')
                    $q.Enqueue(@{                        
                        NamespaceID = '8adf73b7-389a-4276-b638-fe1653f7efc7'
                        SecurityToken = "$/$(if ($ProjectID) { $ProjectID })/$(if ($teamID) { $teamid } else { [guid]::Empty } )"
                    } + $PSBoundParameters)
                }
                Plan {
                    $q.Enqueue(@{                        
                        NamespaceID = 'bed337f8-e5f3-4fb9-80da-81e17d06e7a8'
                        SecurityToken = "Plan"
                    } + $PSBoundParameters)
                }
                Tagging {
                    $q.Enqueue(@{                        
                        NamespaceID = 'bb50f182-8e5e-40b8-bc21-e8752a1e7ae2'
                        SecurityToken = "/$ProjectID"
                    } + $PSBoundParameters)
                }
                ManageTFVC {
                    $q.Enqueue(@{                        
                        NamespaceID = 'a39371cf-0841-4c16-bbd3-276e341bc052'
                        SecurityToken = "/$ProjectID"
                    } + $PSBoundParameters)
                }
                'BuildDefinition|BuildPermission' {

                    $q.Enqueue(@{                        
                        NamespaceID = 'a39371cf-0841-4c16-bbd3-276e341bc052'
                        SecurityToken = "$ProjectID$(($BuildPath -replace '\\','/').TrimEnd('/'))/$DefinitionID"
                    } + $PSBoundParameters)
                    $q.Enqueue(@{                        
                        NamespaceID = 'c788c23e-1b46-4162-8f5e-d7585343b5de'
                        SecurityToken = "$ProjectID$(($BuildPath -replace '\\','/').TrimEnd('/'))/$DefinitionID"
                    } + $PSBoundParameters)
                }
                'RepositoryID|AllRepositories|ProjectRepository' {
                    $q.Enqueue(@{                        
                        NamespaceID = '2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87'
                        SecurityToken = "repo$(
if ($psCmdlet.ParameterSetName -eq 'AllRepositories') {'s'})V2$(
if ($ProjectID) { '/' + $projectId}
)$(
if ($repositoryID) {'/' + $repositoryID}
)$(
if ($BranchName) {
    '/refs/heads/' + ([BitConverter]::ToString([Text.Encoding]::Unicode.GetBytes($BranchName)).Replace('-','').ToLower())
}
)"

                    } + $PSBoundParameters)
                }
            }
        } else {
            $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
        }
    }
    end {
        $c, $t, $progId = 0, $q.Count, [Random]::new().Next()

        while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).            

            $uri = # The URI is comprised of
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

            $realAllow = 0
            $realDeny  = 0
            if (-not $cachedNamespaces.$namespaceID) {
                $cachedNamespaces.$namespaceID =
                    Get-ADOPermission -Organization $Organization -PersonalAccessToken $psboundParameters["PersonalAccessToken"] -PermissionType |
                        Where-Object NamespaceID -EQ $NamespaceID |
                        Select-Object -First 1
            }

            if (-not $cachedNamespaces.$namespaceID) { continue }

            $Descriptors = @($Descriptor) + @(
                foreach ($id in $Identity) {
                    $realId = @(& $resolveIdentity $id)
                    if (-not $realID) {
                        Write-Warning "Could not find Identity: '$realId'"
                        continue
                    }
                    if ($realId.Length -gt 1) {
                        Write-Warning "Ambiguous Identity found: '$id' could be '$($realId -join "','")'"
                        continue
                    }
                    $realId.descriptor
                }
            )

            $friendlyAllow = @(:nextAllow foreach ($Allowed in $Allow) {
                if ($Allowed -match '^\d+$') {
                    $realAllow = $realAllow -bor $Allowed
                } else {
                    foreach ($act in $cachedNamespaces.$namespaceID.actions) {
                        if ($act.Name -like $Allowed -or $act.DisplayName -like $Allowed) {
                            $realAllow = $realAllow -bor $act.bit
                            $act.Name
                            continue nextAllow
                        }
                    }
                    Write-Warning "Permission '$Allowed' not found in '$($cachedNamespaces.$NamespaceID.Name)'.
$($cachedNamespaces.$namespaceID.actions | Format-Table -Property Name, DisplayName | Out-String)"
                }
            })

            $friendlyDeny = @(:nextDeny foreach ($denied in $Deny) {
                if ($denied -match '^\d+$') {
                    $realDeny = $realDeny -bor $denied
                } else {
                    foreach ($act in $cachedNamespaces.$namespaceID.actions) {
                        if ($act.Name -like $denied -or $act.DisplayName -like $denied) {
                            $realDeny = $realDeny -bor $act.bit
                            $act.Name
                            continue nextDeny
                        }
                    }
                    Write-Warning "Permission '$denied' not found in '$($cachedNamespaces.$NamespaceID.Name)'.
$($cachedNamespaces.$namespaceID.actions | Format-Table -Property Name, DisplayName | Out-String)"
                }
            })


            $c++
            Write-Progress "Setting Permissions for $Identity" " (Allowing: $friendlyAllow Denying: $friendlyDeny) on $SecurityToken " -Id $progId -PercentComplete ($c * 100/$t)


            if (-not $Descriptors) {
                Write-Error "No -Descriptor or -Identity provided"
                return
            }

            if (-not $realAllow -and -not $realDeny) {
                Write-Error "Must provide -Allow or -Deny"
                return
            }

            # We want to decorate our return value.  Handily enough, both URIs contain a distinct name in the last URL segment.
            $typename = @($parameterSet -split '/' -notlike '{*}')[-1] -replace 'ies', 'y' # We just need to drop the 's'
            $typeNames = @(
                "$organization.$typename"
                if ($Project) { "$organization.$Project.$typename" }
                "PSDevOps.$typename"
            )
            $invokeParams.Method = 'POST'
            $invokeParams.Body = [Ordered]@{
                token = $SecurityToken
                merge = -not $Overwrite
                inheritPermissions = if ($Inherit) { $true } else { $false}
                # inheritPermissions = $false
                accessControlEntries = @(
                    foreach ($desc in $Descriptors) {
                        if (-not $desc) { continue }
                        [Ordered]@{
                            descriptor = $desc
                            allow = $realAllow
                            deny = $realDeny
                            extendedInfo = @{}
                        }
                    }
                )
            }

            $additionalProperties = @{Organization=$Organization;Server=$Server;SecurityToken=$SecurityToken}
            if ($WhatIfPreference) {
                $invokeParams
                continue
            }

            if ($psCmdlet.ShouldProcess("Update $($cachedNamespaces.$namespaceID.Name) Permissions")) {
                Invoke-ADORestAPI -Uri $uri @invokeParams -PSTypeName $typenames -Property $additionalProperties
            }
        }

        Write-Progress "Setting Permissions for $Identity" " " -Id $progId -Completed
    }
}