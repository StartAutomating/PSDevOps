function Get-ADOArtifactFeed
{
    <#
    .Synopsis
        Gets artifact feeds from Azure DevOps
    .Description
        Gets artifact feeds from Azure DevOps.  Artifact feeds can be used to publish packages.
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/artifacts/feed%20%20management/get%20feeds?view=azure-devops-rest-5.1
    .Example
        Get-ADOArtifactFeed -Organization myOrganization -Project MyProject
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification="Explicitly checking for nulls")]
    [CmdletBinding(DefaultParameterSetName='packaging/Feeds/{FeedId}')]
    [OutputType('PSDevOps.ArtfiactFeed',
        'PSDevOps.ArtfiactFeed.View',
        'PSDevOps.ArtfiactFeed.Change')]
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

    # The name or ID of the feed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('fullyQualifiedId')]
    [string]
    $FeedID,

    # If set, will Get Artifact Feed Views
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/views')]
    [Alias('Views')]
    [switch]
    $View,

    # If set, will get artifact permissions
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/permissions')]
    [Alias('Permissions')]
    [switch]
    $Permission,

    # If set, will get artifact retention policies
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/retentionpolicies')]
    [Alias('RetentionPolicies')]
    [switch]
    $RetentionPolicy,

    # If set, will list packages within a feed.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/packages')]
    [Alias('ListPackages','ListPackage','Packages')]
    [switch]
    $PackageList,

    # If set, will include all versions of packages within a feed.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/packages')]
    [Alias('IncludeAllVersions')]
    [switch]
    $IncludeAllVersion,

    # If set, will include descriptions of a package.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/packages')]
    [switch]
    $IncludeDescription,

    # If provided, will return packages of a given protocol.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/packages')]
    [string]
    $ProtocolType,

    # If set, will get information about a Node Package Manager module.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/npm/{packageName}/versions/{packageVersion}')]
    [Alias('NodePackageManager')]
    [switch]
    $NPM,

    # If set, will get information about a Nuget module.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}')]
    [switch]
    $NuGet,

    # If set, will get information about a Python module.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/pypi/packages/{packageName}/versions/{packageVersion}')]
    [Alias('PyPi')]
    [switch]
    $Python,

    # If set, will get information about a Universal package module.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/upack/packages/{packageName}/versions/{packageVersion}')]
    [Alias('UPack')]
    [switch]
    $Universal,

    # The Package Name.  Must be used with -NPM, -NuGet, -Python, or -Universal.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/upack/packages/{packageName}/versions/{packageVersion}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/npm/{packageName}/versions/{packageVersion}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/pypi/packages/{packageName}/versions/{packageVersion}')]
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedID}/packages')]   
    [string]
    $PackageName,

    # The Package Version.  Must be used with -NPM, -NuGet, -Python, or -Universal.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/upack/packages/{packageName}/versions/{packageVersion}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/npm/{packageName}/versions/{packageVersion}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/nuget/packages/{packageName}/versions/{packageVersion}')]
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/feeds/{feedId}/pypi/packages/{packageName}/versions/{packageVersion}')]
    [string]
    $PackageVersion,

    # The Feed Role
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds')]
    [ValidateSet('Administrator','Collaborator', 'Contributor','Reader')]
    [string]
    $FeedRole,

    # One or more package IDs.  These can be used to get Packages -Metrics.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='packaging/Feeds/{feedId}/packagemetricsbatch')]
    [string[]]
    $PackageID,

    # If set, will get package metrics.
    [Parameter(Mandatory,ParameterSetName='packaging/Feeds/{feedId}/packagemetricsbatch')]
    [Alias('Metrics')]
    [switch]
    $Metric,

    # If set, will include deleted feeds.
    [switch]
    $IncludeDeleted,

    # If set, will get changes in artifact feeds.
    [Alias('Changes')]
    [switch]
    $Change,

    # The server.  By default https://feeds.dev.azure.com/.
    [uri]
    $Server = "https://feeds.dev.azure.com/",

    # The api version.  By default, 5.1-preview.
    [string]
    $ApiVersion = "5.1-preview")
    dynamicParam {
        Invoke-ADORestAPI -DynamicParameter
    }
    begin {
        #region Copy Invoke-ADORestAPI parameters
        $invokeParams = Invoke-ADORestAPI -MapParameter $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters
    
        $q = [Collections.Queue]::new()
    }

    process {
        $in = $_
        $ParameterSet = $psCmdlet.ParameterSetName       
        $q.Enqueue(@{ParameterSet=$ParameterSet;InputObject=$in} + $PSBoundParameters)
    }


    end {
        $c, $t, $id = 0, $q.Count, [Random]::new().Next()

        $metricsBatches = @{}

        :nextInputObject while ($q.Count) {
            . $DQ $q # Pop one off the queue and declare all of it's variables (see /parts/DQ.ps1).
            
            # First, construct a base URI.  It's made up of:
            $uriBase = "$Server".TrimEnd('/'), # * The server
                $Organization, # * The organization
                $(if ($Project) { $project}) -ne $null -join # * an optional project
                '/'

            $subTypeName = ''
            if ($Change) { # If we're looking for changes,
                $subtypeName = '.Change'
                if (-not $FeedID) { # but haven't specified feed
                    $uri = $uriBase, "_apis/packaging/feedchanges?" -join '/'
                } elseif ($Change) {
                    $uri = $uriBase, "_apis/packaging/feeds/$FeedID", 'packagechanges?' -join '/'
                }
            } elseif (-not $Change) {
                $uriParameters = [Regex]::Replace($PSCmdlet.ParameterSetName, '/\{(?<Variable>\w+)\}', {param($match)
                    $var = $ExecutionContext.SessionState.PSVariable.Get($match.Groups['Variable'].ToString())
                    if ($null -ne $var.Value) {
                        return '/' + ($var.Value.ToString())
                    } else {
                        return ''
                    }
                }, 'IgnoreCase,IgnorePatternWhitespace')

                $uri = $uriBase, '_apis', $uriParameters -join '/' # Next, add on the REST api endpoint
                $uri += '?'
            }

            foreach ($typeSwitch in 'View', 'Permission', 'RetentionPolicy', 'NPM', 'Nuget','Python', 'Universal') {
                if ($PSBoundParameters.$typeSwitch -and -not $FeedID) {
                    $splat = @{} + $PSBoundParameters
                    $splat.Remove($typeSwitch)
                    $splat2 =
                    if ('NPM', 'NuGet', 'Python', 'Universal' -contains $typeSwitch) {
                        $splat.Remove('PackageName')
                        $splat.Remove('PackageVersion')
                        $splat + @{$typeSwitch=$true;PackageName=$PackageName;PackageVersion=$PackageVersion}
                    } else {
                        $splat + @{$typeSwitch=$true}
                    }

                    Get-ADOArtifactFeed @splat |
                        & { process {
                            $feedID = $_.FullyQualifiedID
                            $_ | Get-ADOArtifactFeed @splat2 |
                            Add-Member NoteProperty FeedID $feedID -Force -PassThru
                        } }
                    continue nextInputObject
                } elseif ($PSBoundParameters.$typeSwitch) {
                    $subtypeName = ".$typeSwitch"
                }
            }

            if ($Server -ne 'https://feeds.dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }
            $qp = @{"api-version"=$ApiVersion}
            if ($FeedRole) {
                $qp.feedRole = $FeedRole.ToLower()
            }
            if ($IncludeDeleted) {
                if ($packageList) {
                    $qp.includeDeleted = $true
                } else {
                    $qp.includeDeletedUpstreams = $true
                }
            }
            if ($PackageName -and $PackageList) { $qp.PackageName = $PackageName }
            if ($IncludeDescription) { $qp.includeDescription = $true }
            if ($IncludeAllVersion) { $qp.includeAllVersions = $true }
            if ($ProtocolType) { $qp.protocolType = $ProtocolType }

            $invokeParams.Uri = $uri

            if ($PackageList) { $subTypeName = '.Package'}

            $typenames = @( # Prepare a list of typenames so we can customize formatting:
                if ($Organization -and $Project) {
                    "$Organization.$Project.ArtifactFeed$subtypeName" # * $Organization.$Project.ArtifactFeed (if $product exists)
                }
                "$Organization.ArtifactFeed$subtypeName" # * $Organization.ArtifactFeed
                "PSDevOps.ArtifactFeed$subtypeName" # * PSDevOps.ArtifactFeed
            )

            $additionalProperty = @{Organization=$Organization;Server=$Server}
            if ($Project) { $additionalProperty['Project'] = $Project }
            $invokeParams.Property = $additionalProperty
            if (-not $subTypeName) {
                $invokeParams.RemoveProperty = 'ViewID','ViewName'
            } else {
                $invokeParams.Property["FeedID"] = $FeedID
            }


            $invokeParams.PSTypename = $typenames
            $invokeParams.QueryParameter = $qp
            if ($parameterSet -eq 'packaging/Feeds/{feedId}/packagemetricsbatch') { # If we want to get metrics in a batch, let's batch
                if (-not $metricsBatches["$($invokeParams.Uri)"]) {
                    $metricsBatches["$($invokeParams.Uri)"] = @()
                }
                
                $metricsBatches["$($invokeParams.Uri)"] += @{Method='POST';Body=@{packageIds=$PackageID}} + $invokeParams
                continue nextInputObject
            }
            if ($t -gt 1 -and $ProgressPreference -ne 'silentlyContinue') {
                $c++
                Write-Progress "Getting $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$($invokeParams.Uri) " -Id $id -PercentComplete ($c * 100/$t)
            }
            
            # Invoke the REST api
            Invoke-ADORestAPI @invokeParams # decorate results with the Typenames.
        }

        
        if ($metricsBatches.Count) {
            $c, $t = 0, $metricsBatches.Count
            foreach ($batch in $metricsBatches.GetEnumerator()) {
                $packageIdBatch = foreach ($val in $batch.Value) { $val.body.packageIDs }
                $ip = $batch.Value[0]
                $ip.body.packageIDs = $packageIdBatch
                if ($t -gt 1 -and $ProgressPreference -ne 'silentlyContinue') {
                    $c++
                    Write-Progress "Getting $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$($invokeParams.Uri) " -Id $id -PercentComplete ($c * 100/$t)
                }
            
                # Invoke the REST api
                Invoke-ADORestAPI @IP
            }
        }


        if ($t -gt 1 -and $ProgressPreference -ne 'silentlyContinue') {
            Write-Progress "Getting $(@($ParameterSet -split '/' -notlike '{*}')[-1])" "$($invokeParams.Uri) " -Id $id  -Completed
        }

    }

}
