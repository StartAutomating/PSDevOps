function New-ADOArtifactFeed
{
    <#
    .Synopsis
        Creates artifact feeds and views in Azure DevOps
    .Description
        Creates artifact feeds and feed views in Azure DevOps.

        Artifact feeds are used to publish packages.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed?view=azure-devops-rest-5.1
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/create%20feed%20view?view=azure-devops-rest-5.1#feedvisibility
    .Example
        New-ADOArtifactFeed -Organization MyOrg -Project MyProject -Name Builds -Description "Builds of MyProject"
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for nulls")]
    [CmdletBinding(SupportsShouldProcess=$true, DefaultParameterSetName='packaging/feeds')]
    [OutputType('PSDevOps.ArtifactFeed','PSDevOps.ArtifactFeed.View')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Feed Name
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ValidatePattern(
        #?<> -LiteralCharacter '|?/\:&$*"[]>' -CharacterClass Whitespace -Not -Repeat -StartAnchor StringStart -EndAnchor StringEnd
        '\A[^\s\|\?\/\\\:\&\$\*\"\[\]\>]+\z'
    )]
    [string]
    $Name,

    # The feed description.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [ValidatePattern(
        #?<> -CharacterClass Any -Min 1 -Max 255 -StartAnchor StringStart -EndAnchor StringEnd
        '\A.{1,255}\z'
    )]
    [string]
    $Description,

    # If set, this feed will not support the generation of package badges.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [Alias('NoBadges', 'DisabledBadges')]
    [switch]
    $NoBadge,

    # If provided, will allow upstream sources from public repositories.
    # Upstream sources allow your packages to depend on packages in public repositories or private feeds.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [ValidateSet('NPM', 'NuGet','PyPi','Maven', 'PowerShellGallery')]
    [string[]]
    $PublicUpstream,

    # A property bag describing upstream sources
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [PSObject[]]
    $UpstreamSource,

    # If set, will allow package names to conflict with the names of packages upstream.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [switch]
    $AllowConflictUpstream,

    # If set, all packages in the feed are immutable.
    # It is important to note that feed views are immutable; therefore, this flag will always be set for views.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [switch]
    $IsReadOnly,

    # The feed id.  This can be supplied to create a veiw for a particular feed.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/views')]
    [Alias('FullyQualifiedID')]
    [Guid]
    $FeedID = [Guid]::NewGuid(),

    # If set, the feed will not hide all deleted/unpublished versions
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [switch]
    $ShowDeletedPackageVersions,

    # The Feed Role
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds')]
    [ValidateSet('Administrator','Collaborator', 'Contributor','Reader')]
    [string]
    $FeedRole,

    # If set, will create a new view for an artifact feed.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/views')]
    [switch]
    $View,

    # The visibility of the view.  By default, the view will be visible to the entire organization.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/views')]
    [ValidateSet('Collection', 'Organization', 'Private')]
    [string]
    $ViewVisibility = 'Organization',

    # The server.  By default https://feeds.dev.azure.com/.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Server = "https://feeds.dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    [string]
    $ApiVersion = "5.1-preview")

    dynamicParam { . $GetInvokeParameters -DynamicParameter }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = . $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    }

    process {
        $invokeParams.Uri = # First construct the URI.  It's made up of:
            "$(@(
                "$server".TrimEnd('/') # * The Server
                $Organization # * The Organization
                $(if ($Project) { $Project }) # * The Project
                '_apis' #* '_apis'
                . $ReplaceRouteParameter $PSCmdlet.ParameterSetName #* and the replaced route parameters.
            )  -join '/')?$( # Followed by a query string, containing
            @(
                if ($Server -ne 'https://feeds.dev.azure.com/' -and
                    -not $PSBoundParameters.ApiVersion) {
                    $ApiVersion = '2.0'
                }
                if ($ApiVersion) { # an api-version (if one exists)
                    "api-version=$ApiVersion"
                }
            ) -join '&'
            )"
        $subTypeName =
            if ($View) { '.View'}
            else { '' }
        $typenames = @( # Prepare a list of typenames so we can customize formatting:
            if ($Organization -and $Project) {
                "$Organization.$Project.ArtifactFeed$subTypeName" # * $Organization.$Project.ArtifactFeed (if $product exists)
            }
            "$Organization.ArtifactFeed$subTypeName" # * $Organization.ArtifactFeed
            "PSDevOps.ArtifactFeed$subTypeName" # * PSDevOps.ArtifactFeed
        )
        $invokeParams.Method = 'POST' # Next we create the request body.  The Method is always POST.
        if ($PSCmdlet.ParameterSetName -eq 'packaging/feeds') { # If we're creating a feed, populate:
            $invokeParams.Body = @{
                badgesEnabled = -not ($NoBadge -as [bool]) # * If badges are enabled
                isReadOnly = $IsReadOnly -as [bool] # * If the feed is read-only
                hideDeletedPackageVersions  = -not ($ShowDeletedPackageVersions -as [bool]) # * If we are hiding deleted package versions
                description = $Description # * The feed description
                fullyQualifiedID = "$FeedID" # * The FeedID
                name = $Name #* The feed Name
            }

            if ($PublicUpstream) {
                $UpstreamSource = @(
                    if ($PublicUpstream -contains 'NuGet') {
                        [PSCustomObject]@{
                            id= "$([guid]::NewGuid())"
                            name = 'NuGet Gallery'
                            protocol = 'nuget'
                            location = 'https://api.nuget.org/v3/index.json'
                            displayLocation = 'https://api.nuget.org/v3/index.json'
                            upstreamSourceType = 'public'
                        }
                    }
                    if ($PublicUpstream -contains 'NPM') {
                        [PSCustomObject]@{
                            id="$([guid]::NewGuid())"
                            name = 'npmjs'
                            protocol = 'npm'
                            location = 'https://registry.npmjs.org/'
                            displayLocation = 'https://registry.npmjs.org/'
                            upstreamSourceType = 'public'
                        }
                    }
                    if ($PublicUpstream -contains 'PyPI') {
                        [PSCustomObject]@{
                            id="$([guid]::NewGuid())"
                            name = 'PyPi'
                            protocol = 'pypi'
                            location = 'https://pypi.org/'
                            displayLocation = 'https://pypi.org/'
                            upstreamSourceType = 'public'
                        }
                    }
                    if ($PublicUpstream -contains 'Maven') {
                        [PSCustomObject]@{
                            id="$([guid]::NewGuid())"
                            name = 'Maven Central'
                            protocol = 'Maven'
                            location = 'https://repo.maven.apache.org/maven2/'
                            displayLocation = 'https://repo.maven.apache.org/maven2/'
                            upstreamSourceType = 'public'
                        }
                    }
                ) + @(if ($UpstreamSource) { $UpstreamSource })
            }

            if ($UpstreamSource) {
                $invokeParams.Body.UpstreamSources = $UpstreamSource
            }

            if ($FeedRole) { # If we've been provided a -FeedRole,
                $invokeParams.Body.Permissions = @(@{ # add it to the .Permissions property, and force it into a list.
                    role = $FeedRole
                })
            }
        } elseif ($PSCmdlet.ParameterSetName -eq 'packaging/feeds/{feedId}/views') {
            $invokeParams.Body =  @{
                name = $Name
                id = [guid]::NewGuid().ToString()
                type = 'release'
                visibility = $ViewVisibility
            }
        }

        $cmdletBinding =
            $(foreach ($attr in $MyInvocation.MyCommand.ScriptBlock.Attributes) {
                if ($attr -is [CmdletBinding]) { $attr;break }
            })

        $invokeParams.PSTypeName = $typenames

        if ($WhatIfPreference -or $ConfirmPreference -lt $cmdletBinding.ConfirmImpact) {
            $shouldProcessMessage = "$($invokeParams.Method) $($invokeParams.Uri) $($invokeParams.Body | ConvertTo-Json -Depth 100)"
            if ($WhatIfPreference) {
                $invokeParams.Remove('PersonalAccessToken')
                return $invokeParams
            }
        }

        if ($PSCmdlet.ShouldProcess($shouldProcessMessage)) {
            Invoke-ADORestAPI @invokeParams -Property @{
                Organization = $Organization
                Project = $Project
                Server= $Server
            } # decorate results with the Typenames and add common properties.
        }
    }
}