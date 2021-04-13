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
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [string[]]
    $Identity,

    # One or more allow permissions.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [string[]]
    $Allow,

    # One or more deny permissions.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [string[]]
    $Deny,

    # If set, will overwrite this entry with existing entries.
    # By default, will merge permissions for the specified token.
    [Parameter(ValueFromPipelineByPropertyName,
        ParameterSetName='accesscontrolentries/{NamespaceId}')]
    [Alias('NoMerge')]
    [switch]
    $Overwrite,

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
        $q.Enqueue(@{ParameterSet=$ParameterSet} + $PSBoundParameters)
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
                    Get-ADOPermission -Organization $Organization -PersonalAccessToken $psboundParameters["PersonalAccessToken"] |
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

            $friendlyAllow = @(foreach ($Allowed in $Allow) {
                if ($Allowed -match '^\d+$') {
                    $realAllow = $realAllow -bor $Allowed
                } else {
                    foreach ($act in $cachedNamespaces.$namespaceID.actions) {
                        if ($act.Name -like $Allowed -or $act.DisplayName -like $Allowed) {
                            $realAllow = $realAllow -bor $act.bit
                            $act.Name
                        }
                    }
                }
            })

            $friendlyDeny = @(foreach ($denied in $Deny) {
                if ($denied -match '^\d+$') {
                    $realDeny = $realDeny -bor $denied
                } else {
                    foreach ($act in $cachedNamespaces.$namespaceID.actions) {
                        if ($act.Name -like $denied -or $act.DisplayName -like $denied) {
                            $realDeny = $realDeny -bor $act.bit
                            $act.Name
                        }
                    }
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