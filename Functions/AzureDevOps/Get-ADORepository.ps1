function Get-ADORepository
{
    <#
    .Synopsis
        Gets repositories from Azure DevOps
    .Description
        Gets the repositories from Azure DevOps.

        By default, this will return the project's git repositories.

        You can get additional details by piping back into Get-ADORepository with a number of switches:

        * ```Get-ADORepository | Get-ADORepository -PullRequest # Lists pull requests```
        * ```Get-ADORepository | Get-ADORepository -FileList    # Lists files in a repository```
        * ```Get-ADORepository | Get-ADORepository -GitRef      # Lists git refs for a repository```
        

        Azure DevOps repositories can have more than one type of SourceProvider.

        To list the Source Providers, use -SourceProvider

        We can get repositories for a given -ProviderName.
    .Example
        Get-ADORepository -Organization StartAutomating -Project PSDevOps
    .Link
        Remove-ADORepository
    .Link
        https://docs.microsoft.com/en-us/rest/api/azure/devops/build/source%20providers/list%20repositories
    #>
    [CmdletBinding(DefaultParameterSetName='git/repositories')]
    [OutputType('PSDevOps.Repository',
        'PSDevOps.Repository.SourceProvider',
        'PSDevOps.Repository.File',
        'PSDevOps.Repoistory.Recycled')]
    param(
    # The Organization
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Org')]
    [string]
    $Organization,

    # The Project
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Project,

    # The Repository ID
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/commits',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pullrequests/{pullRequestId}',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pushes',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/refs',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/stats/branches',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/trees/{TreeID}',ValueFromPipelineByPropertyName)]        
    [string]
    $RepositoryID,

    # If set, will list commits associated with a given repository.
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/commits')]
    [Alias('ListCommit', 'Commit')]
    [switch]
    $CommitList,
    
    # If provided, will -Skip N items.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/commits')]
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests')]
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pushes')]
    [int]
    $Skip,

    # If provided, will return the -First N items.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/commits')]
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/refs')]
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests')]
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pushes')]
    [int]
    $First,

    # If set, will get the file list from a repository
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('Item','Items','Files','ListFile', 'ListFiles')]
    [switch]
    $FileList,

    # When getting a -FileList, the recursion level.  By default, full.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [ValidateSet('full','None','oneLevel','oneLevelPlusNestedEmptyFolders')]
    [string]
    $RecursionLevel = 'full',

    # When getting a -FileList, the path scope.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('PathScope')]
    [string]
    $ScopePath,

    # The version string identifier (name of tag/branch, SHA1 of commit)
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('Version')]
    [string]
    $VersionDescriptor,

    # The version options (e.g. firstParent, previousChange)
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [ValidateSet('none','firstParent','previousChange')]
    [string]
    $VersionOption,

    # The version type (e.g. branch, commit, or tag)
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [ValidateSet('branch','commit','tag')]
    [string]
    $VersionType,

    # If -IncludeContentMetadata is set a -FileList will include content metadata.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [Alias('IncludeContentMetadata')]
    [switch]
    $IncludeMetadata,

    # If set, will include the parent repository
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/items',ValueFromPipelineByPropertyName)]
    [switch]
    $Download,

    # If set, will list pull requests related to a git repository.
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('PR')]
    [switch]
    $PullRequest,

    # If set, will list git references related to a repository.
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/refs',ValueFromPipelineByPropertyName)]
    [Alias('Refs')]
    [switch]
    $GitRef,

    # If set, will list git branch statistics related to a repository.
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/stats/branches',ValueFromPipelineByPropertyName)]
    [Alias('Branches','BranchStats', 'BranchStatistics')]
    [switch]
    $BranchStatistic,

    # If provided, will output a tree of commits.
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/trees/{TreeID}',ValueFromPipelineByPropertyName)]    
    [string]
    $TreeId,

    # Filters pull requests, returning requests created by the -CreatorIdentity.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('CreatorID')]
    [string]
    $CreatorIdentity,

    # Filters pull requests where the -ReviewerIdentity is a reviewer.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('ReviewerID')]
    [string]
    $ReviewerIdentity,

    # Filters pull requests where the source branch is the -SourceReference.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('SourceRef','SourceRefName')]
    [string]
    $SourceReference,

    # Filters pull requests where the target branch is the -TargetReference.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [Alias('TargetRef','TargetRefName')]
    [string]
    $TargetReference,

    # Filters pull requests with a paricular status.  If not specified, will default to Active.
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/pullrequests',ValueFromPipelineByPropertyName)]
    [ValidateSet('abandoned','active', 'all','completed', 'notset')]
    [Alias('PRStatus')]
    [string]
    $PullRequestStatus,

    # Get pull request with a specific id
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pullrequests/{pullRequestId}',ValueFromPipelineByPropertyName)]
    [Alias('PRID')]
    [string]
    $PullRequestID,

    # If set, will list pushes associated with a repository
    [Parameter(Mandatory,ParameterSetName='git/repositories/{repositoryId}/pushes',ValueFromPipelineByPropertyName)]
    [Alias('ListPush', 'ListPushes', 'PushesList')]
    [switch]
    $PushList,

    # If set, will include the parent repository
    [Parameter(ParameterSetName='git/repositories/{repositoryId}',ValueFromPipelineByPropertyName)]
    [switch]
    $IncludeParent,

    # If set, will get repositories from the recycle bin
    [Parameter(Mandatory,ParameterSetName='git/recycleBin/repositories',ValueFromPipelineByPropertyName)]
    [Alias('RecycleBin')]
    [switch]
    $Recycled,

    # If set, will include hidden repositories.
    [Parameter(ParameterSetName='git/repositories')]
    [Alias('IncludeHiddenRepository','IncludeHiddenRepositories')]
    [switch]
    $IncludeHidden,

    # If set, will include all related links to a repository.
    [Parameter(ParameterSetName='git/repositories')]
    [Parameter(ParameterSetName='git/repositories/{repositoryId}/refs')]
    [Alias('IncludeLinks')]
    [switch]
    $IncludeLink,

    # If set, will return all GitHub remote URLs associated with a repository.
    [Parameter(ParameterSetName='git/repositories')]
    [Alias('IncludeRemoteURLs')]
    [switch]
    $IncludeRemoteUrl,


    # If set, will list repository source providers
    [Parameter(Mandatory,ParameterSetName='sourceproviders',ValueFromPipelineByPropertyName)]
    [Alias('SourceProviders')]
    [switch]
    $SourceProvider,

    # The name of the Source Provider.  This will get all repositories associated with the project.
    # If the -ProviderName is not TFVC or TFGit, an -EndpointID is also required
    [Parameter(Mandatory,ParameterSetName='sourceproviders/{ProviderName}/repositories',ValueFromPipelineByPropertyName)]
    [Parameter(Mandatory,ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [Alias('EndpointType')]
    [string]
    $ProviderName,

    # The name of the Source Provider.  This will get all repositories associated with the project.
    # If the -ProviderName is not TFVC or TFGit, an -EndpointID is also required
    [Parameter(ParameterSetName='sourceproviders/{ProviderName}/repositories',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $EndpointID,

    # The name of the repository
    [Parameter(Mandatory,ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryName,

    # The path within the repository.
    # To use this parameter, -ProviderName is also required, and -EndpointID will be required if the -ProviderName is not TFVC or TFGit
    [Parameter(Mandatory,ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $Path,

    # The commit or branch.  By default, Master.
    [Parameter(ParameterSetName='sourceProviders/{ProviderName}/filecontents',ValueFromPipelineByPropertyName)]
    [string]
    $CommitOrBranch = 'master',


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
        $invokeParams = & $getInvokeParameters $PSBoundParameters
        #endregion Copy Invoke-ADORestAPI parameters

        $q = [Collections.Queue]::new()

    }

    process {
        $q.Enqueue(@{psParameterSet= $psCmdlet.ParameterSetName} + $psBoundParameters)

    }

    end {

        $c, $t, $progId =0, $q.Count, [Random]::new().Next()
        while ($q.Count) {
            . $DQ $q
            if ($t -gt 1) {
                $c++
                Write-Progress "Getting Repositories" "$Server $Organization/$Project" -PercentComplete ($c * 100 / $t) -Id $progId
            }

            $uri = # The URI is comprised of:
                @(
                    "$server".TrimEnd('/') # the Server (minus any trailing slashes),
                    $Organization          # the Organization,
                    $Project               # the Project,
                    '_apis'                # the API Root ('_apis'),
                    (. $ReplaceRouteParameter $PSParameterSet)
                                           # and any parameterized URLs in this parameter set.
                ) -as [string[]] -ne '' -join '/'
            
            $qp = [Ordered]@{}
            if ($IncludeParent) { # includeParent=True (if it was set)
                $qp.includeParent = "True"
            }
            if ($EndpointID) {
                $qp.serviceEndpointId="$EndpointID"
            }

            if ($IncludeLink) {
                $qp.includeLinks   = "$IncludeLink".ToLower()
            }

            if ($repositoryName) {
                $qp.repository     = $repositoryName
                $qp.commitOrBranch = $CommitOrBranch
            }

            $subTypeName = ''


            if ($psParameterSet -eq 'git/repositories') {
                $qp.includeHidden  = $IncludeHidden -as [bool]                
                $qp.includeAllUrls = $true
            }

            if ($psParameterSet -eq 'git/repositories/{repositoryId}/commits') {
                $subTypeName = '.Commit'
                if ($Skip) {
                    $qp.'searchCriteria.$skip' = $Skip
                }
                if ($First) {
                    $qp.'searchCriteria.$top' = $First
                }
            }
            

            # If we're getting repository items
            if ($psParameterSet -eq 'git/repositories/{repositoryId}/items') { 
                $subTypeName = '.File' # Set the subtypenmae to .File
                # Map the following to query parameters: 
                if ($IncludeMetadata) { 
                    $qp.includeContentMetadata = 'true' #* IncludeMetadata->?includeContentMetadata=true
                }
                if ($RecursionLevel) {
                    $qp.recursionLevel=$recursionLevel  #* RecursionLevel->?recursionLevel
                }

                if ($Download) { #* Download->?download=true
                    $qp.download = 'true'
                } else {
                    $qp.'$format'= 'json' #* '$format'='json' (if -not $download)
                }

                if ($scopePath) { 
                    $qp.scopePath=$scopePath #* ScopePath->?scopePath
                }

                if ($Latest) { 
                    $qp.latestProcessedChange='true' #* Latest->?latestProcessedChange=true
                }
                if ($VersionDescriptor) {
                    $qp."versionDescriptor.version" = $VersionDescriptor
                }

                if ($VersionType) {
                    $qp."versionDescriptor.type"=$VersionType
                }
            }
                        
            if ($psParameterSet -in 'git/repositories/{repositoryId}/pullRequests',
                'git/repositories/{repositoryId}/pullrequests/{pullRequestId}') {
                $subTypeName = ".PullRequest"
                if ($CreatorIdentity) {
                    $qp.'searchCriteria.creatorId' = $CreatorIdentity
                }
                if ($SourceReference) {
                    $qp."searchCriteria.sourceRefName"=$SourceReference
                }

                if ($PullRequestStatus) {
                    $qp."searchCriteria.status"=$PullRequestStatus
                }

                if ($TargetReference) {
                    $qp."searchCriteria.targetRefName"=$TargetReference
                }

                if ($ReviewerIdentity) {
                    $qp."searchCriteria.reviewerID"=$ReviewerIdentity
                }

                if ($Skip) {
                    $qp.'$skip' = $Skip
                }
                if ($First) {
                    $qp.'$top' = $First
                }
            }

            if ($psParameterSet -eq 'git/repositories/{repositoryId}/pushes') {
                $subTypeName = '.Push'
                if ($Skip) {
                    $qp.'$skip' = $Skip
                }
                if ($First) {
                    $qp.'$top' = $First
                }
                if ($IncludeLink) {
                    $qp.'searchCriteria.includeLinks' = "$true"
                }
            }

            if ($psParameterSet -eq 'git/repositories/{repositoryId}/refs') {
                $subTypeName = '.GitRef'                
                if ($First) {
                    $qp.'$top' = $First
                }
            }
            
            if ($psParameterSet -eq 'git/repositories/{repositoryId}/stats/branches') {
                $subTypeName = '.Branch'
            }

            if ($psParameterSet -eq 'git/repositories/{repositoryId}/trees/{TreeID}') {
                $subTypeName = '.Tree'
            }

            if ($psParameterSet -eq 'git/recycleBin/repositories') {
                $subTypeName = '.Recycled'
            }

            if ($psParameterSet -eq 'sourceProviders') {
                $subTypeName = '.SourceProvider'
            }

            
            if ($psParameterSet -eq 'sourceproviders/{ProviderName}/repositories') {
                $subTypeName = ".$ProviderName.Repository"
                $invokeParams.ExpandProperty = 'repositories'
                $invokeParams.Property.EndpointID = $EndpointID
                $invokeParams.Property.ProviderName = $ProviderName
            }            

            if ($path) {
                $qp.path=$path
            }

            if ($Server -ne 'https://dev.azure.com/' -and
                -not $PSBoundParameters.ApiVersion) {
                $ApiVersion = '2.0'
            }

            if ($ApiVersion) { # and the apiVersion
                $qp."api-version"=$ApiVersion
            }

            $invokeParams.QueryParameter = $qp

            $InvokeParams.Property =
                @{
                    # Because we want to pipeline properly, also return the -Organization and -Project as properties.
                    Organization = $Organization
                    Project = $Project
                    Server = $Server
                }

            if ($RepositoryID) {
                $invokeParams.Property.RepositoryID = $RepositoryID
            }
                
            # Invoke the ADO Rest API.
            Invoke-ADORestAPI @invokeParams -Uri $uri -PSTypeName @(
                # Because we want to format the output, decorate the object with the following typenames:
                "$Organization.$Project.Repository$subTypeName" # * $Organization.$Project.Repository$SubTypeName
                "$Organization.Repository$subTypeName" # * $Organization.Repository$SubTypeName
                "PSDevOps.Repository$subTypeName" # * PSDevOps.Repository$SubTypeName
            )
        }

        Write-Progress "Getting Repositories" ' ' -Completed -Id $progId
    }
}
